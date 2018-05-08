function drawVehicle(VehicleList,CarLength,CarWidth,printLabel)

for i = 1:length(VehicleList)
    PosX = VehicleList(i).position.x;
    PosY = VehicleList(i).position.y;
    phi = VehicleList(i).heading;
    recX0=[-CarLength/2 CarLength/2 CarLength/2 -CarLength/2 -CarLength/2];
    recY0=[-CarWidth/2 -CarWidth/2 CarWidth/2 CarWidth/2 -CarWidth/2];
    RrecX0=recX0*cos(phi)-recY0*sin(phi);
    RrecY0=recX0*sin(phi)+recY0*cos(phi);
    recX=RrecX0 + PosX;
    recY=RrecY0 + PosY;
    if VehicleList(i).hasRequested == 0
        color = [0.9 0.2 0.1];
    else 
        color = [0.3 0.3 0.6];
    end
    line(recX,recY,'Color', color);
    if printLabel == 1
        text(PosX,PosY,num2str(VehicleList(i).ID))
    end
    if printLabel == 2
        text(PosX,PosY,num2str(VehicleList(i).speed,3))
    end
end