function drawVehicle(VehicleList,CarLength,CarWidth,printLabel)

for i = 1:length(VehicleList)
    PosX = VehicleList(i).position.x;
    PosY = VehicleList(i).position.y;
    phi = VehicleList(i).heading;
    color = VehicleList(i).color;
    recX0=[-CarLength/2 CarLength/2 CarLength/2 -CarLength/2 -CarLength/2];
    recY0=[-CarWidth/2 -CarWidth/2 CarWidth/2 CarWidth/2 -CarWidth/2];
    RrecX0=recX0*cos(phi)-recY0*sin(phi);
    RrecY0=recX0*sin(phi)+recY0*cos(phi);
    recX=RrecX0 + PosX;
    recY=RrecY0 + PosY;

    line(recX,recY,'Color', color);
%     recY(end)=[];
%     recX(end)=[];
%     fill(recX,recY,color)
    if printLabel == 1
        text(PosX,PosY,num2str(VehicleList(i).ID))
    end
    if printLabel == 2
        text(PosX,PosY,num2str(VehicleList(i).speed,3))
    end
end