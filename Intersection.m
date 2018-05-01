%  Author : Mohammad Khayatian
%  Arizona State University
% 
%
%
%
%
clc;
clear all;
close all;
rng(44)
% Parameters
SimulationTime = 270;       % Seconds
StepTime = 0.1;            % Seconds
flow = 0.03;                   % Car/Second/Road
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
TransmitLine = 150;
TurnSpace = 2;
%% Print parameters
printStep = 5;
printLabel = 0;         %% no print = 0, print ID = 1, print Speed = 2;

%% Car Parameters
CarLength = 6;
CarWidth = 2;
L = 5;
amax = 100;
amin = -90;
minSpeed = 10;
maxSpeed = 15;
CarGenerationDuration = SimulationTime - 40;
%% Intersection Manager
ComputationSpeedFactor = 5;
RequestedVehiclesList = [];
Vmax = 15;
Vmin = 2;
%% Simulation
count = 0;
time = 0;
ID = 0;
Distancethreshold = sqrt((CarLength/2)^2 + (CarWidth/2)^2) + 0.1;
failureCheck = 0;
VehicleList = [];
Network = [];
failures = [];
GeneratedCarTimeStamp = SpawnThreshold * rand(1,NumberOfRoads * NumberOfLanesPerRoad);
while (time < SimulationTime)
    time = count * StepTime;
    %% Safety Checking
    if failureCheck == 1
        for i = 1 : length(VehicleList)
            First = VehicleList(i);
            for j = 1 : length(VehicleList)
                Secondnd = VehicleList(j);
                d = sqrt( (VehicleList(i).position.x - VehicleList(j).position.x)^2 + (VehicleList(i).position.y - VehicleList(j).position.y)^2);
                if (i ~= j) && (d < Distancethreshold) % if distance is less than Distancethreshold
                    failures = [failures;VehicleList(i).ID VehicleList(j).ID d];
                end
            end
        end
    end
                
    
    %% Vehicle Generation
    for Lane = 1 : NumberOfRoads * NumberOfLanesPerRoad
        if (time >= GeneratedCarTimeStamp(Lane) && time < CarGenerationDuration)
            ID = ID + 1;
            VehicleList = [VehicleList; generateCar(Lane,ID,IntersectionBounds,laneWidth,minSpeed,maxSpeed)];
            GeneratedCarTimeStamp(Lane) = time + SpawnThreshold + rand;
        end
    end
    
    %% Vehicles
    if ~isempty(VehicleList)
        [Network, VehicleList] = SendToNetwork(VehicleList, Network, IntersectionBounds, TransmitLine);
        [Network, VehicleList] = ReceiveFromNetwork(VehicleList, Network);
        VehicleList = PathPlanning(VehicleList,laneWidth,IntersectionBounds,TurnSpace,Vmax);
        VehicleList = ACC(VehicleList,CarLength);               % Adaptive Cruise Control
        VehicleList = vehicleDynamics(VehicleList,L,StepTime,amax,amin);
    end
    %% Remove out of bound vehicles
    car = 1;
    while car < length(VehicleList) + 1                
        if (VehicleList(car).position.x > IntersectionBounds.xb4) || ...
           (VehicleList(car).position.x < IntersectionBounds.xb1) || ...
           (VehicleList(car).position.y < IntersectionBounds.yb1) || ...
           (VehicleList(car).position.y > IntersectionBounds.yb4)
              VehicleList(car)=[];
              car = car - 1;
        end
        car=car+1;
    end
    
    
    %% Intersection Manager (IM)
    for iteration = 1 : ComputationSpeedFactor
        [Network, RequestedVehiclesListNew] = IntersectionManagement(Network, RequestedVehiclesList,Vmax,Vmin,laneWidth,TransmitLine,time,CarLength);
        RequestedVehiclesList = RequestedVehiclesListNew;
    end
    
    %% Network (Wireless)
    
    
    
    %% drawing
    if rem(count,printStep)==0
        drawVehicle(VehicleList,CarLength,CarWidth,printLabel)
        drawIM(IntersectionBounds,TransmitLine,laneWidth)
%         text(80,100,'time');text(100,100,num2str(time));
%         text(80,120,'Network');text(120,120,num2str(length(Network)));
        axis ([IntersectionBounds.xb1 IntersectionBounds.xb4 IntersectionBounds.yb1 IntersectionBounds.yb4])
        ax = gcf;
        ax.Position = [1 41 1920 963];
        zlim([0 45]);
        view(50,85)
        grid on
        pause(0.0001)
        cla
    end
    count = count + 1;
end
drawIM(IntersectionBounds,TransmitLine,laneWidth)
axis ([IntersectionBounds.xb1-10 IntersectionBounds.xb4+10 IntersectionBounds.yb1-10 IntersectionBounds.yb4+10])
ax = gcf;
ax.Position = [1 41 1920 963];
disp(failures)
