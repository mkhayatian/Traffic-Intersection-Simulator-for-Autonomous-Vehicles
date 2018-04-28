function VehicleList = vehicleDynamics(VehicleList,L,h,amax,amin)
Kp = 50;
Ki = 5;
Kd = 0.0001;
for i = 1:length(VehicleList)
    x = VehicleList(i).position.x;
    y = VehicleList(i).position.y;
    phi = VehicleList(i).heading;
    v = VehicleList(i).speed;
    sai = VehicleList(i).sai;
    a = VehicleList(i).acceleration;
    desiredSpeed = VehicleList(i).desiredSpeed;
    %% Controller
    if abs(desiredSpeed - v)>0.001
        integralError = VehicleList(i).integralError;
        previousSpeed = VehicleList(i).previousSpeed;
        speedError = desiredSpeed - v;
        integralError = integralError + speedError * h;
        derivativeError = (previousSpeed - v)/h;
        a = Kp * speedError + Ki * integralError + Kd * derivativeError;
        
        VehicleList(i).integralError = integralError;
    end
        
        
        
    
    
    %% Differential Eq.
    if sai > 3*pi/4
        sai = 3*pi/4;
    end
    if sai < -3*pi/4
        sai =-3*pi/4;
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