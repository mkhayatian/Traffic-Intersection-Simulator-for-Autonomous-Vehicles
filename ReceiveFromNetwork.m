function [Network, VehicleList] = ReceiveFromNetwork(VehicleList, Network)

for i = 1:length(VehicleList)
    if (VehicleList(i).hasRequested == 1)
        for j = 1:length(Network)
            if strcmp(Network(j).to , num2str(VehicleList(i).ID))
                VehicleList(i).desiredSpeed = Network(j).msg.assignedVelocity;
                Network(j) = [];
                break
            end
        end
    end
end
    