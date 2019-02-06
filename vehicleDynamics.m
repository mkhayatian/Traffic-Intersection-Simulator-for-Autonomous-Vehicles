function VehicleList = vehicleDynamics(VehicleList,L,h,amax,amin,time,method,TransmitLine,Vmax,Vmin,IntersectionBounds,CarLength)
if strcmp(method,'Crossroads')
    Kp = 0.5/h;
    Ki = 0.05/h;
    Kd = 0.000001/h;
    for i = 1:length(VehicleList)
        x = VehicleList(i).position.x;
        y = VehicleList(i).position.y;
        phi = VehicleList(i).heading;
        v = VehicleList(i).speed;
        sai = VehicleList(i).sai;
        a = VehicleList(i).acceleration;
        ActuationTimestamp = VehicleList(i).ActuationTimestamp;
        desiredSpeed = VehicleList(i).desiredSpeed;
        %% Controller
        if abs(desiredSpeed - v)>0.001 && time > ActuationTimestamp
            integralError = VehicleList(i).integralError;
            previousSpeed = VehicleList(i).previousSpeed;
            speedError = desiredSpeed - v;
            integralError = integralError + speedError * h;
            derivativeError = (previousSpeed - v)/h;
            a = Kp * speedError + Ki * integralError + Kd * derivativeError;

            VehicleList(i).integralError = integralError;
        end





        %% Differential Eq.
        if sai > pi/4
            sai = pi/4;
        end
        if sai < -pi/4
            sai =-pi/4;
        end
        xnew = x + h * (v .* cos( phi ));
        ynew = y + h * (v .* sin( phi ));
        phinew = phi + h * ((v / L) .* tan( sai ));
        if a > amax
            a = amax;
        end
        if a < amin
            a = amin;
        end
        vnew = v + h * (a);
        VehicleList(i).position.x = xnew;
        VehicleList(i).position.y = ynew;
        VehicleList(i).heading = phinew;
        VehicleList(i).speed = vnew;
        VehicleList(i).sai = sai;
        VehicleList(i).acceleration = a;
        VehicleList(i).previousSpeed = v;
    end
elseif strcmp(method,'RIM')
    Kpp = 0.5/h;
    Kip = 0.05/h;
    Kdp = 0.00001/h;
    for i = 1:length(VehicleList)
        x = VehicleList(i).position.x;
        y = VehicleList(i).position.y;
        phi = VehicleList(i).heading;
        v = VehicleList(i).speed;
        Lane = VehicleList(i).lane;
        ID = VehicleList(i).ID;
        if (Lane == 1 || Lane == 2 || Lane == 3)
            position = 0;
            POA = -x;
            distanceToIntersection = 0 - x;
        elseif (Lane == 4 || Lane == 5 || Lane == 6)
            position = 0;
            POA = -y;
            distanceToIntersection = 0 - y;
        elseif (Lane == 7 || Lane == 8 || Lane == 9)
            position = 0;
            POA = x - VehicleList(i).IMWidth;
            distanceToIntersection = x - VehicleList(i).IMWidth;
        elseif (Lane == 10 || Lane == 11 || Lane == 12)
            position = 0;
            POA = y - VehicleList(i).IMWidth;
            distanceToIntersection = y - VehicleList(i).IMWidth;
        end
        sai = VehicleList(i).sai;
        a = VehicleList(i).acceleration;
        TOA = VehicleList(i).ActuationTimestamp;
        VOA = VehicleList(i).desiredSpeed;
        %% Controller
        if VehicleList(i).hasReceived == 1
            rTOA = TOA - time;
            A0 = (6 * (2 * position - 2 * POA + rTOA * v + rTOA * VOA) ) / rTOA ^ 3;       % calculate coefficient of trajectory
            B0 = -(2 * (3 * position - 3 * POA + 2 * rTOA * v + rTOA * VOA) ) / rTOA ^ 2;    % calculate coefficient of trajectory
            VehicleList(i).trajectory.A0 = A0;
            VehicleList(i).trajectory.B0 = B0;
            VehicleList(i).hasReceived = 2;
        elseif VehicleList(i).hasReceived == 2 
            if distanceToIntersection > 0
                if ID == 1
%                     disp('here');
                end

                A0 = VehicleList(i).trajectory.A0;
                B0 = VehicleList(i).trajectory.B0;
                v0 = VehicleList(i).receiveSpeed;
                rx = VehicleList(i).receivePosition;
                x0 = 0;
                t0 = VehicleList(i).receiveTimestamp;
                t = time - t0;
                xr = (1 / 6) * A0 * t ^ 3 + (1 / 2) * B0 * t ^ 2 + v0 * t + x0;
                integralError = VehicleList(i).integralError;
                previousSpeed = VehicleList(i).previousSpeed;
                PositionError = xr - (rx-distanceToIntersection);
                integralError = integralError + PositionError * h;
                derivativeError = (previousSpeed - position)/h;
                a = Kpp * PositionError + Kip * integralError + Kdp * derivativeError;
                VehicleList(i).integralError = integralError;
            else 
                a=amax;             % accelerate
            end
        end
        %% Differential Eq.
        if sai > pi/4
            sai = pi/4;
        end
        if sai < -pi/4
            sai =-pi/4;
        end
        xnew = x + h * (v .* cos( phi ));
        ynew = y + h * (v .* sin( phi ));
        phinew = phi + h * ((v / L) .* tan( sai ));
        if a > amax
            a = amax;
        end
        if a < amin
            a = amin;
        end
        if v > Vmax
            a = 0;
        end
        if v < Vmin
            a = 0;
        end
        vnew = v + h * (a);
        VehicleList(i).position.x = xnew;
        VehicleList(i).position.y = ynew;
        VehicleList(i).heading = phinew;
        VehicleList(i).speed = vnew;
        VehicleList(i).sai = sai;
        VehicleList(i).acceleration = a;
        VehicleList(i).previousSpeed = position;
    end
elseif strcmp(method,'TrafficLight')
    Kp = 0.5/h;
    Ki = 0.05/h;
    Kd = 0.000001/h;
    for i = 1:length(VehicleList)
        if length(VehicleList)>5
%             disp('aaa');
        end
        x = VehicleList(i).position.x;
        y = VehicleList(i).position.y;
        phi = VehicleList(i).heading;
        v = VehicleList(i).speed;
        sai = VehicleList(i).sai;
        a = VehicleList(i).acceleration;
        ActuationTimestamp = VehicleList(i).ActuationTimestamp;
%         desiredSpeed = v;
        Lane = VehicleList(i).lane;
        stopTime = -v/amin;
        stopDistance = 0.5*amin*stopTime^2+v*stopTime+CarLength/2;
%         desiredSpeed = v;
        timer = 60;
        t=rem(time,timer);
        yellowTime=4;  % yellow time
        red123 = (t>0 && t<yellowTime/2) || (t>timer/2+yellowTime/2 && t<timer);
        yellow123 = (t>timer/2-yellowTime/2 && t<timer/2+yellowTime/2);
        green123 = t>yellowTime/2 && t<timer/2-yellowTime/2;
        
        if (red123) && (Lane == 1 || Lane == 2 || Lane == 3) 
           if  x > IntersectionBounds.xb2 - stopDistance && x < IntersectionBounds.xb2
               a=amin;
           end
        end
        if (red123) && (Lane == 7 || Lane == 8 || Lane == 9)
           if  x < IntersectionBounds.xb3 + stopDistance && x > IntersectionBounds.xb3
               a=amin;
           end
        end
        
        if (yellow123) &&(Lane == 1 || Lane == 2 || Lane == 3) 
            if  x > IntersectionBounds.xb2 - stopDistance && x < IntersectionBounds.xb2
               a=amax;
            end
        end
        if (yellow123) && (Lane == 7 || Lane == 8 || Lane == 9)
           if  x < IntersectionBounds.xb3 + stopDistance && x > IntersectionBounds.xb3
               a=amax;
           end
        end
        
        if (green123) && (Lane == 1 || Lane == 2 || Lane == 3) 
               a=amax;
        end
        if (green123) && (Lane == 7 || Lane == 8 || Lane == 9)
               a=amax;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        red456 = (t>yellowTime/2 && t<timer/2+yellowTime/2);
        yellow456 = (t>0 && t<yellowTime/2) || (t>timer-yellowTime/2 && t<timer);
        green456 = (t>timer/2+yellowTime/2 && t<timer-yellowTime/2);
        if  (red456) && (Lane == 4 || Lane == 5 || Lane == 6) 
           if  y > IntersectionBounds.yb2 - stopDistance && y < IntersectionBounds.yb2 
               a=amin;
           end
        end
        if (red456) && (Lane == 10 || Lane == 11 || Lane == 12)
            if  y < IntersectionBounds.yb3 + stopDistance && y > IntersectionBounds.yb3
               a=amin;
            end
        end
        
        if  (yellow456) && (Lane == 4 || Lane == 5 || Lane == 6) 
           if  y > IntersectionBounds.yb2 - stopDistance && y < IntersectionBounds.yb2 
               a=amax;
           end
        end
        if (yellow456) && (Lane == 10 || Lane == 11 || Lane == 12)
            if  y < IntersectionBounds.yb3 + stopDistance && y > IntersectionBounds.yb3
               a=amax;
            end
        end
        
        if (green456) && (Lane == 4 || Lane == 5 || Lane == 6) 
               a=amax;
        end
        if (green456) && (Lane == 10 || Lane == 11 || Lane == 12)
               a=amax;
        end
        %% Differential Eq.
        if sai > pi/4
            sai = pi/4;
        end
        if sai < -pi/4
            sai = -pi/4;
        end
        xnew = x + h * (v .* cos( phi ));
        ynew = y + h * (v .* sin( phi ));
        phinew = phi + h * ((v / L) .* tan( sai ));
        if a > amax
            a = amax;
        end
        if a < amin
            a = amin;
        end
        vnew = v + h * (a);
        if vnew < 0
            vnew = 0;
        end
        if vnew > Vmax
            vnew = Vmax;
        end
        VehicleList(i).position.x = xnew;
        VehicleList(i).position.y = ynew;
        VehicleList(i).heading = phinew;
        VehicleList(i).speed = vnew;
        VehicleList(i).sai = sai;
        VehicleList(i).acceleration = a;
        VehicleList(i).previousSpeed = v;
    end
end