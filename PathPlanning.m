function VehicleList = PathPlanning(VehicleList,laneWidth,IntersectionBounds,TurnSpace, Vmax, TransmitLine,h)
KdSai = 0.1/h;
KpSai = 0.001/h;
for i = 1:length(VehicleList)
    x = VehicleList(i).position.x;
    y = VehicleList(i).position.y;
    Lane = VehicleList(i).lane;
    xb1 = IntersectionBounds.xb1;
    xb2 = IntersectionBounds.xb2; 
    xb3 = IntersectionBounds.xb3;
    xb4 = IntersectionBounds.xb4;
    yb1 = IntersectionBounds.yb1;
    yb2 = IntersectionBounds.yb2;
    yb3 = IntersectionBounds.yb3;
    yb4 = IntersectionBounds.yb4;
    DestinationLane = VehicleList(i).DestinationLane;
    %% lane changing
%     if (Lane == 1 && x < IntersectionBounds.xb2 - TransmitLine)     % if it's in range
%         if (DestinationLane == 8)   % need to change lane (to right)
%             found = 0;
%             for j = 1 :length(VehicleList)
%                 if i ~= j
%                     x2 = VehicleList(j).position.x;
%                     y2 = VehicleList(j).position.y;
%                     Lane2 = VehicleList(j).lane;
%                     dist = sqrt((x2-x)^2+(y2-y)^2);
%                     if Lane2 == Lane 
%                         if dist < 20
%                             % slow down
%                             found = 1;
%                             if VehicleList(i).speed > 2
%                                 VehicleList(i).speed = VehicleList(i).speed - 1;
%                             end
%                         end    
%                     end
%                 end 
%             end
%             if found == 0
%                 % change lane
%                 yr = yb2 + 1.5 * laneWidth;
%                 HeadingError = yr - y;
%                 DerivativeError = HeadingError - VehicleList(i).headingError;
%                 sai = KpSai * HeadingError + KdSai * DerivativeError;
%                 VehicleList(i).headingError =  yr - y;
%                 VehicleList(i).sai = sai;
%                 if x > IntersectionBounds.xb2 - TransmitLine - 5
%                     VehicleList(i).lane = Lane2;
%                 end
%             end
%         end
%     else
%         VehicleList(i).sai = 0; % back to normal
%     end
%     %%
%     if (Lane == 2 && x < IntersectionBounds.xb2 - TransmitLine)     % if it's in range
%         if (DestinationLane == 4 || DestinationLane == 7 || DestinationLane == 9 || DestinationLane == 12)   % need to change lane (to right)
%             found = 0;
%             for j = 1 :length(VehicleList)
%                 if i ~= j
%                     x2 = VehicleList(j).position.x;
%                     y2 = VehicleList(j).position.y;
%                     Lane2 = VehicleList(j).lane;
%                     dist = sqrt((x2-x)^2+(y2-y)^2);
%                     if Lane2 == Lane 
%                         if dist < 20
%                             % slow down
%                             found = 1;
%                             if VehicleList(i).speed > 2
%                                 VehicleList(i).speed = VehicleList(i).speed - 1;
%                             end
%                         end    
%                     end
%                 end 
%             end
%             if found == 0
%                 % change lane
%                 if (DestinationLane == 4 || DestinationLane == 7)
%                     yr = yb2 + 0.5 * laneWidth;
%                 elseif (DestinationLane == 9 || DestinationLane == 12)
%                     yr = yb2 + 2.5 * laneWidth;
%                 end
%                 HeadingError = yr - y;
%                 DerivativeError = HeadingError - VehicleList(i).headingError;
%                 sai = KpSai * HeadingError + KdSai * DerivativeError;
%                 VehicleList(i).headingError =  yr - y;
%                 VehicleList(i).sai = sai;
%                 if x > IntersectionBounds.xb2 - TransmitLine - 5
%                     VehicleList(i).lane = Lane2;
%                 end
%             end
%         end
%     else
%         VehicleList(i).sai = 0; % back to normal
%     end
    %% Max speed when leave the intersection
    if (Lane == 1) && ((x > IntersectionBounds.xb3) || (y > IntersectionBounds.yb3))
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 2) && (x > IntersectionBounds.xb3)
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 3) && ((x > IntersectionBounds.xb3) || (y < IntersectionBounds.yb2))
        VehicleList(i).desiredSpeed = Vmax;
    end
    
    if (Lane == 4) && ((x < IntersectionBounds.xb2) || (y > IntersectionBounds.yb3))
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 5) && (y > IntersectionBounds.yb3)
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 6) && ((x > IntersectionBounds.xb3) || (y > IntersectionBounds.yb3))
        VehicleList(i).desiredSpeed = Vmax;
    end
    
    if (Lane == 7) && ((x < IntersectionBounds.xb2) || (y < IntersectionBounds.yb2))
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 8) && (x < IntersectionBounds.xb2)
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 9) && ((x < IntersectionBounds.xb2) || (y > IntersectionBounds.yb3))
        VehicleList(i).desiredSpeed = Vmax;
    end
    
    if (Lane == 10) && ((x > IntersectionBounds.xb3) || (y < IntersectionBounds.yb2))
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 11) && (y < IntersectionBounds.yb2)
        VehicleList(i).desiredSpeed = Vmax;
    end
    if (Lane == 12) && ((x < IntersectionBounds.xb2) || (y < IntersectionBounds.yb2))
        VehicleList(i).desiredSpeed = Vmax;
    end
    %% Left and Right Turns
    if (Lane == 1) && (x > IntersectionBounds.xb2) && (DestinationLane == 12)  % a left turn 
        VehicleList(i).phiref=pi/2;
        xRef = IntersectionBounds.xb2 + 7*laneWidth/2;
        e=xRef-x;
        VehicleList(i).sai = 0.35*( VehicleList(i).phiref - VehicleList(i).heading)-0.01*e;
    end
    if (Lane == 3) && (x > IntersectionBounds.xb2-TurnSpace) && (DestinationLane == 4)  % a right turn 
        VehicleList(i).phiref=-pi/2;
        xRef = IntersectionBounds.xb2 + 1*laneWidth/2;
        e=xRef-x;
        sai = 0.93*( VehicleList(i).phiref - VehicleList(i).heading)+0.09*e;
        VehicleList(i).sai = sai;
    end
    if (Lane == 4) && (y > IntersectionBounds.yb2) && (DestinationLane == 3)  % a left turn 
        VehicleList(i).phiref=pi;
        yRef = IntersectionBounds.yb2 + 7*laneWidth/2;
        e=yRef-y;
        VehicleList(i).sai = 0.35*( VehicleList(i).phiref - VehicleList(i).heading)-0.01*e;
    end
    if (Lane == 6) && (y > IntersectionBounds.yb2-TurnSpace) && (DestinationLane == 7)  % a right turn 
        VehicleList(i).phiref=0;
        yRef = IntersectionBounds.yb2 + 1*laneWidth/2;
        e=yRef-y;
        sai = 0.93*( VehicleList(i).phiref - VehicleList(i).heading)+0.09*e;
        VehicleList(i).sai = sai;
    end
    if (Lane == 7) && (x < IntersectionBounds.xb3) && (DestinationLane == 6)  % a left turn 
        VehicleList(i).phiref=3*pi/2;
        xRef = IntersectionBounds.xb2 + 5*laneWidth/2;
        e=xRef-x;
        VehicleList(i).sai = 0.35*( VehicleList(i).phiref - VehicleList(i).heading)+0.01*e;
    end
    if (Lane == 9) && (x < IntersectionBounds.xb3+TurnSpace) && (DestinationLane == 10)  % a right turn 
        VehicleList(i).phiref=pi/2;
        xRef = IntersectionBounds.xb2 + 11*laneWidth/2;
        e=xRef-x;
        sai = 0.93*( VehicleList(i).phiref - VehicleList(i).heading)-0.09*e;
        VehicleList(i).sai = sai;
    end
    if (Lane == 10) && (y < IntersectionBounds.yb3) && (DestinationLane == 9)  % a left turn 
        VehicleList(i).phiref=2*pi;
        yRef = IntersectionBounds.yb2 + 5*laneWidth/2;
        e=yRef-y;
        VehicleList(i).sai = 0.35*( VehicleList(i).phiref - VehicleList(i).heading)+0.01*e;
    end
    if (Lane == 12) && (y < IntersectionBounds.yb3+TurnSpace) && (DestinationLane == 1)  % a right turn 
        VehicleList(i).phiref=pi;
        yRef = IntersectionBounds.yb2 + 11*laneWidth/2;
        e=yRef-y;
        sai = 0.93*( VehicleList(i).phiref - VehicleList(i).heading)-0.09*e;
        VehicleList(i).sai = sai;
    end
end