function [Network, VehicleList] = ReceiveFromNetwork(VehicleList, Network,time)

for i = 1:length(VehicleList)
    if (VehicleList(i).hasRequested == 1)
        for j = 1:length(Network)
            if strcmp(Network(j).to , num2str(VehicleList(i).ID)) && time > Network(j).delay +Network(j).timestamp % condition for network delay
                VehicleList(i).desiredSpeed = Network(j).msg.assignedVelocity;
                VehicleList(i).ActuationTimestamp = Network(j).timestamp;
                Network(j) = [];
                break
            end
        end
    end
end
    