%  Author : Mohammad Khayatian
%  Arizona State University

clc;
clear all;
close all;
rng(4444);
% for iter = 1:6
flows = 0.001:0.001:0.02;
for op = 1:length(flows)
% v = VideoWriter('mohi.avi');          % for video capturing
% open(v);                              % for video capturing
rng(441);                                % load random number generator with seed = 4444;
% Parameters
SimulationTime = 360*1;       % Seconds
timer = 60;     % traffic light timer period
YL=4;           % yellow time    
StepTime = 0.1;            % Seconds
flow = flows(op);                % Car/Second/Road
SpawnThreshold = 1/flow;    % Seconds
NumberOfRoads = 4;          % DON'T CHANGE
NumberOfLanesPerRoad = 3;    % DON'T CHANGE
IMWidth = 60;
IntersectionBounds = struct;
IntersectionBounds.xb1 = -200;
IntersectionBounds.xb2 = 0;
IntersectionBounds.xb3 = IMWidth;
IntersectionBounds.xb4 = IMWidth -IntersectionBounds. xb1;
IntersectionBounds.yb1 = IntersectionBounds.xb1;
IntersectionBounds.yb2 = IntersectionBounds.xb2;
IntersectionBounds.yb3 = IntersectionBounds.xb3;
IntersectionBounds.yb4 = IntersectionBounds.xb4;
laneWidth = (IntersectionBounds.xb3-IntersectionBounds.xb2)/(NumberOfLanesPerRoad*2);
TransmitLine = 100*1;
TurnSpace = 2;
averageDelay = 0;
%% Print parameters
printStep = 200000;
printLabel = 2;         %% no print = 0, print ID = 1, print Speed = 2;
print3D = 0;            %% 3D = 1, 2D = 0;
%% Car Parameters for generation
CarLength = 6*(4.0);
CarWidth = 2;
L = 5;
amax = 5;
amin = -6;
minSpeed = 11.2;
maxSpeed = 22.3;
CarGenerationDuration = SimulationTime - 50;
%% Network
Log = 0;            % 1 for logging all packets
%% Intersection Manager for assignemt
method = 'Crossroads';
% method = 'RIM';
% method = 'TrafficLight';
ComputationSpeedFactor = 10;
RequestedVehiclesList = [];
Vmax = maxSpeed;
Vmin = 2;
%% Simulation
count = 1;
WCRTD = 1.1*1; %WORST CASE ROUND-TRIP DELAY (Seconds)
WCND = 0.1; %WORST-CASE NETWORK DELAY (Seconds)
time = 0;
ID = 0;
%% flow rate measurement
incoming = 0; % # of incoming vehicles
outgoing = 0; % # of outgoing vehicles
t2Window = 100;
t1Widnow = 200;
%% 
Distancethreshold = sqrt((CarLength/2)^2 + (CarWidth/2)^2) + 0.1;
failureCheck = 1;
VehicleList = [];
Network = [];
failures = [];
c1 = 1;
GeneratedCarTimeStamp = SpawnThreshold * rand(1,NumberOfRoads * NumberOfLanesPerRoad);
while (time < SimulationTime)
    tic
    time = count * StepTime;   
    %% Vehicle Generation
    for Lane = 1 : NumberOfRoads * NumberOfLanesPerRoad
        if (time >= GeneratedCarTimeStamp(Lane) && time < CarGenerationDuration)
            ID = ID + 1;
            if time < t1Widnow && time > t2Window
                incoming = incoming + 1;
            end
            VehicleList = [VehicleList; generateCar(Lane,ID,IntersectionBounds,laneWidth,minSpeed,maxSpeed,time,method)];
            GeneratedCarTimeStamp(Lane) = time + SpawnThreshold + rand;
        end
    end
    
    %% Vehicles
    if ~isempty(VehicleList)
        
        [Network, VehicleList] = SendToNetwork(VehicleList, Network, IntersectionBounds, TransmitLine,time,WCND,Log);
        [Network, VehicleList] = ReceiveFromNetwork(VehicleList, Network,time); 
        VehicleList = PathPlanning(VehicleList,laneWidth,IntersectionBounds,TurnSpace,Vmax,TransmitLine,StepTime);
        VehicleList = ACC(VehicleList,CarLength,amin);               % Adaptive Cruise Control 
        VehicleList = vehicleDynamics(VehicleList,L,StepTime,amax,amin,time,method,TransmitLine,Vmax,Vmin,IntersectionBounds,CarLength);
        
    end
    
    %% Log the speed
%     if ~isempty(VehicleList)
%         for idd = 1:ID
%             for car = 1:length(VehicleList)
%                 if VehicleList(car).ID==idd
%                     AllCarsVelocity(count,idd)=VehicleList(car).speed;
%                     AllCarsAcc(count,idd)=VehicleList(car).acceleration;
%                 end
%             end
%         end
%     end
    %% Remove out of bound vehicles
    car = 1;
    while car < length(VehicleList) + 1                
        if (VehicleList(car).position.x > IntersectionBounds.xb4) || ...
           (VehicleList(car).position.x < IntersectionBounds.xb1) || ...
           (VehicleList(car).position.y < IntersectionBounds.yb1) || ...
           (VehicleList(car).position.y > IntersectionBounds.yb4)
            averageDelay(c1) = time - VehicleList(car).spawnTime;
            
            c1 = c1 + 1;
            if time < t1Widnow && time > t2Window
                outgoing = outgoing + 1;
            end
            VehicleList(car)=[];
            car = car - 1;
        end
        car=car+1;
    end
    
    
    %% Intersection Manager (IM)
    
    for iteration = 1 : ComputationSpeedFactor
        [Network, RequestedVehiclesListNew] = IntersectionManagement(Network, RequestedVehiclesList,...
        Vmax,Vmin,laneWidth,TransmitLine,time,CarLength,WCRTD,WCND,Log,method,IMWidth);
        RequestedVehiclesList = RequestedVehiclesListNew;
    end
    
    %% drawing
    
    if rem(count,printStep)==0 
%         text(80,100,'time');text(100,100,num2str(time));
%         text(80,120,'Network');text(120,120,num2str(length(Network)));
        
        ax = gcf;
        text(-100,-100,num2str(time))
        if print3D == 1
            drawVehicle3D(VehicleList,CarLength,CarWidth,printLabel)
            drawIM3D(IntersectionBounds,TransmitLine,laneWidth)
            zlim([0 40]);
            view(30,85)
            ax.Position = [438 300 1245 604];
        else 
            drawVehicle(VehicleList,CarLength,CarWidth,printLabel)
            drawIM(IntersectionBounds,TransmitLine,laneWidth,method,time,timer,YL)
            ax.Position = [123 18 1281 963];
        end
        grid on
        axis ([IntersectionBounds.xb1 IntersectionBounds.xb4 IntersectionBounds.yb1 IntersectionBounds.yb4])
        pause(0.00001)
%         frame = getframe(ax);         % for video capturing
%         writeVideo(v,frame);      % for video capturing
        cla
    end
    
    count = count + 1;
    elpsed1(count+1)=toc;
    

end
drawIM(IntersectionBounds,TransmitLine,laneWidth,method,time,timer,YL)
axis ([IntersectionBounds.xb1-10 IntersectionBounds.xb4+10 IntersectionBounds.yb1-10 IntersectionBounds.yb4+10])
% disp(failures)
AVG(op) = sum(averageDelay)/ID;
% [ID sum(averageDelay)]
% AVG(iter,op) = sum(averageDelay)/ID;
end
% end
% end
AVG =AVG';
% close(v);                         % for video capturing
