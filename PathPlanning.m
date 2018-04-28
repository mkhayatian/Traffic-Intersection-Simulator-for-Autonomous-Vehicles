function VehicleList = PathPlanning(VehicleList,laneWidth,IntersectionBounds,TurnSpace, Vmax)
for i = 1:length(VehicleList)
    x = VehicleList(i).position.x;
    y = VehicleList(i).position.y;
    Lane = VehicleList(i).lane;
    DestinationLane = VehicleList(i).DestinationLane;
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