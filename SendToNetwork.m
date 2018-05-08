function [NetworkBuffer, VehicleList] = SendToNetwork(VehicleList, NetworkBuffer,IntersectionBounds,TransmitLine,time,WCND,Log)

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
                Packet.timestamp =time;
                Packet.msg.DestinationLane = DestinationLane;
                Packet.delay = 0.2*rand;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
                if Log == 1
                    disp(['A packet from ID = ',num2str(ID),'. V=',num2str(v),' X=', num2str(x),'Y=',num2str(y),'t=',num2str(time)]);
                end
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
                Packet.timestamp =time;
                Packet.msg.DestinationLane = DestinationLane;
                Packet.delay = 0.2*rand;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
                if Log == 1
                    disp(['A packet from ID = ',num2str(ID),'. V=',num2str(v),' X=', num2str(x),'Y=',num2str(y),'t=',num2str(time)]);
                end
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
                Packet.timestamp =time;
                Packet.msg.DestinationLane = DestinationLane;
                Packet.delay = 0.2*rand;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
                if Log == 1
                    disp(['A packet from ID = ',num2str(ID),'. V=',num2str(v),' X=', num2str(x),'Y=',num2str(y),'t=',num2str(time)]);
                end
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
                Packet.timestamp =time;
                Packet.msg.DestinationLane = DestinationLane;
                Packet.delay = WCND*rand;
                NetworkBuffer = [NetworkBuffer; Packet];
                VehicleList(i).hasRequested = 1;
                if Log == 1
                    disp(['A packet from ID = ',num2str(ID),'. V=',num2str(v),' X=', num2str(x),'Y=',num2str(y),'t=',num2str(time)]);
                end
            end
        end
    end
end
