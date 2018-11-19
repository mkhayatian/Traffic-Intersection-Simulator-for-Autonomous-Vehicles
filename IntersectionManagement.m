function [Network,RequestedVehiclesList] = IntersectionManagement(Network,RequestedVehiclesListPrevious,Vmax,Vmin,laneWidth,TransmitLine,TIME,CarLength,WCRTD,WCND,Log,method,IMWidth)
if strcmp(method , 'Crossroads')
    RequestedVehiclesList = RequestedVehiclesListPrevious;  % keep track of vehicles
    arc = 2 * pi * (3.5*laneWidth) /4;
    smallArc = 2 * pi * (0.5*laneWidth) /4;
    SafetyTimeBuffer = 0.2;
    %% In and Out cases
    InNOuts = [1 9;1 12;2 8;3 7;3 4;4 12;4 3;5 11;6 10;6 7;7 3;7 6;8 2;9 1;9 10;10 6;10 9;11 5;12 4;12 1];

    %% Checking and management
    if ~isempty(Network)
        ii = 1;
        found = 0;
        while (ii <= length(Network)) && (found == 0)
            if strcmp(Network(ii).to, 'IM') && TIME >  Network(ii).delay + Network(ii).msg.timestamp     % delay in the network condition 
               Packet = Network(ii);
               %% Unmarshaling the packet
               ID = Packet.ID;
               Lane = Packet.msg.lane;
               timestamp = Packet.msg.timestamp;
               x1 = Packet.msg.position.x;
               y1 = Packet.msg.position.y;
               v1 = Packet.msg.speed;
               DestinationLane1 = Packet.msg.DestinationLane;
               if (Lane == 1 || Lane == 2 || Lane == 3)
                   x1 = (TIME - timestamp) * v1 + x1;
               elseif (Lane == 4 || Lane == 5 || Lane == 6)
                   y1 = (TIME - timestamp) * v1 + y1;
               elseif (Lane == 7 || Lane == 8 || Lane == 9)
                   x1 = -(TIME - timestamp) * v1 + x1;
               elseif (Lane == 10 || Lane == 11 || Lane == 12)
                   y1 = -(TIME - timestamp) * v1 + y1;
               end
               car = struct;
               car.ID = ID;
               car.lane = Lane;
               car.speed = v1;
               car.position.x = x1;
               car.position.y = y1;
               car.DestinationLane = DestinationLane1;
               %% IM management code
               if isempty(RequestedVehiclesList)
                   assignedVelocity = Vmax;
               else
                   inOut1 = [car.lane car.DestinationLane];
                   for jj = 1:length(RequestedVehiclesList)
                        ID2 = RequestedVehiclesList(jj).ID;
                        lane2 = RequestedVehiclesList(jj).lane;
                        v2 = RequestedVehiclesList(jj).speed;
                        x2 = RequestedVehiclesList(jj).position.x;
                        y2 = RequestedVehiclesList(jj).position.y;
                        DestinationLane2 = RequestedVehiclesList(jj).DestinationLane;
                        assignedVelocity2 = RequestedVehiclesList(jj).assigned;
                        inOut2 = [lane2 DestinationLane2];
                        Now = TIME;
                        TravelledDistance2 = (Now - RequestedVehiclesList(jj).TimeOfRequest)*assignedVelocity2;
                        if TravelledDistance2 > 200
                            RequestedVehiclesList(jj).finished = 1;
                        end
                        % get conflict point
                        %%% Left turn
                        d1 = 0;
                        d2 = 0;
                        Combination = [inOut1 inOut2];
                        for Road = 0 : 3 : 9
                            C = Combination + Road;               % construct new combination for other roads
                            for kk = 1 : 4
                                if C(kk) > 12
                                    C(kk) = rem(C(kk),12);
                                end
                            end
                            if isequal([1 12 4 3] , C)
                                d1 = arc/5;%%
                                d2 = 4*arc/5; %%
                                break;
                            end
                            if isequal([1 12 4 12] , C)
                                d1 = 4*arc/5;%%
                                d2 = 6.0*laneWidth;%%
                                break;
                            end
                            if isequal([1 12 7 3]  , C)
                                d1 = arc/3;
                                d2 = 4.0*laneWidth;
                            end
                            if isequal([1 12 8 2]  , C)
                                d1 = arc/2;
                                d2 = 3.5*laneWidth;
                                break;
                            end
                            if isequal([1 12 9 1]  , C)
                                d1 = 4*arc/5;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 12 10 9]  , C)
                                d1 = arc/2;
                                d2 = arc/2;
                                break;
                            end
                            if isequal([1 12 10 6]  , C)
                                d1 = arc/3;
                                d2 = 3.5*laneWidth;
                                break;
                            end
                            if isequal([1 12 11 5]  , C)
                                d1 = arc/5;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 12 12 4]  , C)
                                d1 = 0;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            %%% Straight left lane
                            if isequal([1 9 4 3]  , C)
                                d1 = 1.5*laneWidth;
                                d2 = 4*arc/5;
                                break;
                            end
                            if isequal([1 9 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 3.0*laneWidth;
                            end
                            if isequal([1 9 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 7 6]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 2*arc/3;
                                break;
                            end
                            if isequal([1 9 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 10 9]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([1 9 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            %%% Straigh mid lane
                            if isequal([2 8 4 3]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 2*arc/3;
                                break;
                            end
                            if isequal([2 8 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 7 6]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([2 8 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            %%% Straigh right lane
                            if isequal([3 7 4 3]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = arc/3;
                                break;
                            end
                            if isequal([3 7 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 6 7]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = smallArc;
                                break;
                            end
                            if isequal([3 7 7 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([3 7 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            %%% Right turn
                            if isequal([3 4 12 4]  , C)
                                d1 = 0;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                        end
                        % DX2 = distance inside the intersection + distance
                        % from intersection + vehicleLength/2 - travelled
                        % distance after WCRTD seconds.
                        DX2 = d2 + (TransmitLine - TravelledDistance2) + CarLength/2 - WCRTD * v2;
                        TimeOfConflict = DX2/assignedVelocity2;
                        DT = TimeOfConflict + SafetyTimeBuffer;
                        DX1 = d1 + TransmitLine - CarLength/2 - WCRTD * v1;
                        Velocity(jj) = DX1/DT;

                        if DX2<=0
                             Velocity(jj) = Vmax;       % the car is already passed the conflict point
                        end
                        if Velocity(jj) > Vmax
                            Velocity(jj) = Vmax;
                        end
    %                     if d1 == 0
    %                         Velocity(jj)=Vmax;
    %                     end
                   end      


                   assignedVelocity = min(Velocity);

    %                assignedVelocity = 4.44; %% TO BE EDITTED

               end

               %% Delete The First Packet in the Queue
               Network(ii) = [];

               %% Marshaling the response packet
               if assignedVelocity < Vmin
                   error('Facing traffic JAM!')
               end
               car.assigned = assignedVelocity;
               ResponsePacket = struct;
               ResponsePacket.to = num2str(ID);
               ResponsePacket.ID = 0;
               ResponsePacket.delay = WCND*rand;
               ResponsePacket.msg.timestamp = timestamp+WCRTD;       % SET THE ACTUATION TIMESTAMP
               ResponsePacket.msg.assignedVelocity = assignedVelocity;
               ResponsePacket.msg.IMWidth = IMWidth;
               car.TimeOfRequest = timestamp;
               car.finished = 0;
               Network = [Network;ResponsePacket];
               if Log == 1
                   disp(['A packet from IM to ID =',num2str(ID),' V=',num2str(assignedVelocity),' Tactuation=', num2str(timestamp+WCRTD)]);
               end
               RequestedVehiclesList = [RequestedVehiclesList;car];
               found = 1;
            end
            ii = ii+1;
       end

    end
    i = 1;
    while i < length(RequestedVehiclesList) + 1
       if RequestedVehiclesList(i).finished == 1
           RequestedVehiclesList(i) = [];
           i = i - 1;
       end
       i = i + 1;
    end
%%    else if the protocol is RIM
elseif strcmp(method , 'RIM')
    RequestedVehiclesList = RequestedVehiclesListPrevious;  % keep track of vehicles
    arc = 2 * pi * (3.5*laneWidth) /4;
    smallArc = 2 * pi * (0.5*laneWidth) /4;
    SafetyTimeBuffer = 0.2;
    %% In and Out cases
    InNOuts = [1 9;1 12;2 8;3 7;3 4;4 12;4 3;5 11;6 10;6 7;7 3;7 6;8 2;9 1;9 10;10 6;10 9;11 5;12 4;12 1];

    %% Checking and management
    if ~isempty(Network)
        ii = 1;
        found = 0;
        while (ii <= length(Network)) && (found == 0)
            if strcmp(Network(ii).to, 'IM') && TIME >  Network(ii).delay + Network(ii).timestamp     % delay in the network condition 
               Packet = Network(ii);
               %% Unmarshaling the packet
               ID = Packet.ID;
               Lane = Packet.msg.lane;
               timestamp = Packet.timestamp;
               x1 = Packet.msg.position.x;
               y1 = Packet.msg.position.y;
               v1 = Packet.msg.speed;
               DestinationLane1 = Packet.msg.DestinationLane;
               if (Lane == 1 || Lane == 2 || Lane == 3)
                   x1 = (TIME - timestamp) * v1 + x1;
               elseif (Lane == 4 || Lane == 5 || Lane == 6)
                   y1 = (TIME - timestamp) * v1 + y1;
               elseif (Lane == 7 || Lane == 8 || Lane == 9)
                   x1 = -(TIME - timestamp) * v1 + x1;
               elseif (Lane == 10 || Lane == 11 || Lane == 12)
                   y1 = -(TIME - timestamp) * v1 + y1;
               end
               car = struct;
               car.ID = ID;
               car.lane = Lane;
               car.speed = v1;
               car.position.x = x1;
               car.position.y = y1;
               car.DestinationLane = DestinationLane1;
               %% IM management code
               if isempty(RequestedVehiclesList)
                   assignedTOA = TransmitLine/Vmax + TIME;
                   assignedVOA = Vmax;
               else
                   inOut1 = [car.lane car.DestinationLane];
                   for jj = 1:length(RequestedVehiclesList)
                        ID2 = RequestedVehiclesList(jj).ID;
                        lane2 = RequestedVehiclesList(jj).lane;
                        v2 = RequestedVehiclesList(jj).speed;
                        x2 = RequestedVehiclesList(jj).position.x;
                        y2 = RequestedVehiclesList(jj).position.y;
                        DestinationLane2 = RequestedVehiclesList(jj).DestinationLane;
                        VOA2 = RequestedVehiclesList(jj).assigned.VOA;
                        TOA2 = RequestedVehiclesList(jj).assigned.TOA;
                        inOut2 = [lane2 DestinationLane2];
                        Now = TIME;
%                         TravelledDistance2 = (Now - RequestedVehiclesList(jj).TimeOfRequest)*assignedVelocity2;
                        if TIME > TOA2
                            RequestedVehiclesList(jj).finished = 1;
                        end
                        % get conflict point
                        %%% Left turn
                        d1 = 0;
                        d2 = 0;
                        Combination = [inOut1 inOut2];
                        for Road = 0 : 3 : 9
                            C = Combination + Road;               % construct new combination for other roads
                            for kk = 1 : 4
                                if C(kk) > 12
                                    C(kk) = rem(C(kk),12);
                                end
                            end
                            if isequal([1 12 4 3] , C)
                                d1 = arc/5;%%
                                d2 = 4*arc/5; %%
                                break;
                            end
                            if isequal([1 12 4 12] , C)
                                d1 = 4*arc/5;%%
                                d2 = 6.0*laneWidth;%%
                                break;
                            end
                            if isequal([1 12 7 3]  , C)
                                d1 = arc/3;
                                d2 = 4.0*laneWidth;
                            end
                            if isequal([1 12 8 2]  , C)
                                d1 = arc/2;
                                d2 = 3.5*laneWidth;
                                break;
                            end
                            if isequal([1 12 9 1]  , C)
                                d1 = 4*arc/5;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 12 10 9]  , C)
                                d1 = arc/2;
                                d2 = arc/2;
                                break;
                            end
                            if isequal([1 12 10 6]  , C)
                                d1 = arc/3;
                                d2 = 3.5*laneWidth;
                                break;
                            end
                            if isequal([1 12 11 5]  , C)
                                d1 = arc/5;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 12 12 4]  , C)
                                d1 = 0;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            %%% Straight left lane
                            if isequal([1 9 4 3]  , C)
                                d1 = 1.5*laneWidth;
                                d2 = 4*arc/5;
                                break;
                            end
                            if isequal([1 9 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 3.0*laneWidth;
                            end
                            if isequal([1 9 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 3.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 7 6]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 2*arc/3;
                                break;
                            end
                            if isequal([1 9 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 10 9]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([1 9 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            if isequal([1 9 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 4.0*laneWidth;
                                break;
                            end
                            %%% Straigh mid lane
                            if isequal([2 8 4 3]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 2*arc/3;
                                break;
                            end
                            if isequal([2 8 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 2.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 7 6]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([2 8 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            if isequal([2 8 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 5.0*laneWidth;
                                break;
                            end
                            %%% Straigh right lane
                            if isequal([3 7 4 3]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = arc/3;
                                break;
                            end
                            if isequal([3 7 4 12]  , C)
                                d1 = 3.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 5 11]  , C)
                                d1 = 4.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 6 10]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = 1.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 6 7]  , C)
                                d1 = 5.0*laneWidth;
                                d2 = smallArc;
                                break;
                            end
                            if isequal([3 7 7 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = arc;
                                break;
                            end
                            if isequal([3 7 10 6]  , C)
                                d1 = 2.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 11 5]  , C)
                                d1 = 1.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            if isequal([3 7 12 4]  , C)
                                d1 = 0.0*laneWidth;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                            %%% Right turn
                            if isequal([3 4 12 4]  , C)
                                d1 = 0;
                                d2 = 6.0*laneWidth;
                                break;
                            end
                        end

                        TOA(jj) = TOA2 + d2/VOA2 - d1/Vmax;
                        maxTOA = 100/Vmax+timestamp;
                        if TOA(jj) < maxTOA
                            TOA(jj) = maxTOA;        %% feasible
                        end

                        assignedVOA = Vmax;
                        

                   end      


                   assignedTOA = max(TOA);

    %                assignedVelocity = 4.44; %% TO BE EDITTED

               end

               %% Delete The First Packet in the Queue
               Network(ii) = [];

               %% Marshaling the response packet
%                if assignedTOA > 10
%                    error('Facing traffic JAM!')
%                end
               car.assigned.TOA = assignedTOA;
               car.assigned.VOA = assignedVOA;
               ResponsePacket = struct;
               ResponsePacket.to = num2str(ID);
               ResponsePacket.ID = 0;
               ResponsePacket.delay = WCND*rand;
               ResponsePacket.timestamp = TIME;          % initiation timestamp
%                ResponsePacket.msg.assignedVOA = assignedVOA; % SET THE VOA
%                ResponsePacket.msg.assignedTOA = assignedTOA; % SET THE TOA
               ResponsePacket.msg.timestamp = assignedTOA;              % SET THE TOA
               ResponsePacket.msg.assignedVelocity = assignedVOA;   % SET THE VOA
               ResponsePacket.msg.IMWidth = IMWidth;
               car.TimeOfRequest = timestamp;
               car.finished = 0;
               Network = [Network;ResponsePacket];
               if Log == 1
                   disp(['A packet from IM to ID =',num2str(ID),' VOA=',num2str(assignedVOA),' TOA=', num2str(assignedTOA)]);
               end
               RequestedVehiclesList = [RequestedVehiclesList;car];
               found = 1;
            end
            ii = ii+1;
       end

    end
    i = 1;
    while i < length(RequestedVehiclesList) + 1
       if RequestedVehiclesList(i).finished == 1
           RequestedVehiclesList(i) = [];
           i = i - 1;
       end
       i = i + 1;
    end
end