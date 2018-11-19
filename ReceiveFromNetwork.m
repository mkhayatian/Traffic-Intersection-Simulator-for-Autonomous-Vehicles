function [Network, VehicleList] = ReceiveFromNetwork(VehicleList, Network,time)

for i = 1:length(VehicleList)
    if (VehicleList(i).hasRequested == 1)
        for j = 1:length(Network)
            if strcmp(Network(j).to , num2str(VehicleList(i).ID)) && time > Network(j).delay + Network(j).msg.timestamp % condition for network delay
                VehicleList(i).desiredSpeed = Network(j).msg.assignedVelocity;
                VehicleList(i).ActuationTimestamp = Network(j).msg.timestamp;
                VehicleList(i).receiveTimestamp = time;
                VehicleList(i).receiveSpeed = VehicleList(i).speed;
                Lane = VehicleList(i).lane;
                if (Lane == 1 || Lane == 2 || Lane == 3)
                    position = VehicleList(i).position.x;
                elseif (Lane == 4 || Lane == 5 || Lane == 6)
                    position = VehicleList(i).position.y;
                elseif (Lane == 7 || Lane == 8 || Lane == 9)
                    position = -VehicleList(i).position.x;
                elseif (Lane == 10 || Lane == 11 || Lane == 12)
                    position = -VehicleList(i).position.y;
                end
                VehicleList(i).receivePosition = position;
                VehicleList(i).hasReceived = 1;
                VehicleList(i).IMWidth = Network(j).msg.IMWidth;
                Network(j) = [];
                break
            end
        end
    end
end
    


