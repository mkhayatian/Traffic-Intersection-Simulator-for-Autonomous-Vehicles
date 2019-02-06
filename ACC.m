function VehicleList = ACC(VehicleList,CarLength,amin)
% f = front car
% r = rear car
% DistanceThreshold = 20 + CarLength/2;
for i = 1:length(VehicleList)-1
    xR = VehicleList(i).position.x;
    yR = VehicleList(i).position.y;
    vR = VehicleList(i).speed;
    LaneR = VehicleList(i).lane;
    for j = i+1:length(VehicleList)
        xF = VehicleList(j).position.x;
        yF = VehicleList(j).position.y;
        vF = VehicleList(j).speed;
        LaneF = VehicleList(j).lane;
        distance = sqrt((xF-xR)^2+(yF-yR)^2);
        reachTime = -(vR-vF)/amin;
        reachDistance = 0.5*amin*reachTime^2+vR*reachTime + CarLength;
        if (LaneR == LaneF) && (distance < reachDistance)
            VehicleList(i).desiredSpeed = vF;
        end


    end
        
end
