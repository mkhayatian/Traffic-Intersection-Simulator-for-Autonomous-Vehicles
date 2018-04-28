function VehicleList = ACC(VehicleList,CarLength)
% f = front car
% r = rear car
DistanceThreshold = 10 + CarLength/2;
for i = 1:length(VehicleList)
    xR = VehicleList(i).position.x;
    yR = VehicleList(i).position.y;
%     vR = VehicleList(i).speed;
    LaneR = VehicleList(i).lane;
    for j = 1:length(VehicleList)
        if  j<i
            xF = VehicleList(j).position.x;
            yF = VehicleList(j).position.y;
            vF = VehicleList(j).speed;
            LaneF = VehicleList(j).lane;
            distance = sqrt((xF-xR)^2+(yF-yR)^2);
            if (LaneR == LaneF) && (distance < DistanceThreshold)

                VehicleList(i).desiredSpeed = vF;

            end
                
        end
    end
        
end
