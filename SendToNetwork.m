function [NetworkBuffer, VehicleList] = SendToNetwork(VehicleList, NetworkBuffer,IntersectionBounds,TransmitLine)

BufferSize = 1000; 
if length(NetworkBuffer) > BufferSize
    msg = 'Network Buffer overflow!';
    error(msg);
end
for i = 1:length(VehicleList)
    x = VehicleList(i).position.x;
    y = VehicleList(i).position.y;
    v = VehicleList(i).speed;
    Lane = VehicleList(i).lane;
    hasRequested = VehicleList(i).hasRequested;
    if (hasRequested == 0)
        DestinationLane = VehicleList(i).DestinationLane;
        ID = VehicleList(i).ID;
        if (Lane == 1) || (Lane == 2) || (Lane == 3) 
            if (x > IntersectionBounds.xb2 - TransmitLine) 
                Packet = struct;
                Packet.to = 'IM';
                Packet.ID = ID;
                Packet.msg.lane = Lane;
                Packet.msg.position.x = x;
                Packet.msg.position.y = y;
                Packet.msg.speed = v;
                Packet.msg.DestinationLane = DestinationLane;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
            end
        end
        if (Lane == 4) || (Lane == 5) || (Lane == 6) 
            if (y > IntersectionBounds.yb2 - TransmitLine) 
                Packet = struct;
                Packet.to = 'IM';
                Packet.ID = ID;
                Packet.msg.lane = Lane;
                Packet.msg.position.x = x;
                Packet.msg.position.y = y;
                Packet.msg.speed = v;
                Packet.msg.DestinationLane = DestinationLane;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
            end
        end
        if (Lane == 7) || (Lane == 8) || (Lane == 9) 
            if (x < IntersectionBounds.xb3 + TransmitLine) 
                Packet = struct;
                Packet.to = 'IM';
                Packet.ID = ID;
                Packet.msg.lane = Lane;
                Packet.msg.position.x = x;
                Packet.msg.position.y = y;
                Packet.msg.speed = v;
                Packet.msg.DestinationLane = DestinationLane;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
            end
        end
        if (Lane == 10) || (Lane == 11) || (Lane == 12) 
            if (y < IntersectionBounds.yb3 + TransmitLine) 
                Packet = struct;
                Packet.to = 'IM';
                Packet.ID = ID;
                Packet.msg.lane = Lane;
                Packet.msg.position.x = x;
                Packet.msg.position.y = y;
                Packet.msg.speed = v;
                Packet.msg.DestinationLane = DestinationLane;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
            end
        end
    end
end
