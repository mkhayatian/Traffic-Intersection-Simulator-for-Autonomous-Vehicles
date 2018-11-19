function car = generateCar(Lane,ID,IntersectionBounds,laneWidth,minSpeed,maxSpeed,time)
xb1 = IntersectionBounds.xb1;
xb2 = IntersectionBounds.xb2;
xb3 = IntersectionBounds.xb3;
xb4 = IntersectionBounds.xb4;
yb1 = IntersectionBounds.yb1;
yb2 = IntersectionBounds.yb2;
yb3 = IntersectionBounds.yb3;
yb4 = IntersectionBounds.yb4;
car = struct;
car.spawnTime = time;
car.ID = ID;
car.lane = Lane;
car.acceleration = 0;
car.sai = 0;
car.speed = minSpeed + (maxSpeed - minSpeed)* rand;
car.desiredSpeed = car.speed;
car.integralError = 0;
car.headingError = 0;
car.previousSpeed = car.speed;
car.hasRequested = 0;
car.hasReceived = 0;
car.trajectory.A0 = 0;
car.trajectory.B0 = 0;
colors = lines(30);
car.color = colors(ceil(rand*29),:);
car.ActuationTimestamp = 0;
car.receiveTimestamp = 0;
car.receiveSpeed = 0;
car.receivePosition = 0;
car.IMWidth = 0;


if (Lane == 1)
    car.position.x = xb1 ;
    car.position.y = yb2 + 5*laneWidth/2;
    car.heading = 0;
    car.DestinationLane = datasample([12 9],1);
%     car.DestinationLane = datasample([12 9 8],1);
elseif (Lane == 2)
    car.position.x = xb1 ;
    car.position.y = yb2 + 3*laneWidth/2;
    car.heading = 0;
    car.DestinationLane = datasample([8],1);
%     car.DestinationLane = datasample([4 7 8 9 12],1);
elseif (Lane == 3)
    car.position.x = xb1 ;
    car.position.y = yb2 + 1*laneWidth/2;
    car.heading = 0;
    car.DestinationLane = datasample([4 7],1);
elseif (Lane == 4)
    car.position.x = xb2 + 7*laneWidth/2;
    car.position.y = yb1 ;
    car.heading = pi/2;
    car.DestinationLane = datasample([3 12],1);
elseif (Lane == 5)
    car.position.x = xb2 + 9*laneWidth/2;
    car.position.y = yb1 ;
    car.heading = pi/2;
    car.DestinationLane = datasample([11],1);
elseif (Lane == 6)
    car.position.x = xb2 + 11*laneWidth/2;
    car.position.y = yb1 ;
    car.heading = pi/2;
    car.DestinationLane = datasample([7 10],1);
elseif (Lane == 7)
    car.position.x = xb4 ;
    car.position.y = yb2 + 7*laneWidth/2;
    car.heading = pi;
    car.DestinationLane = datasample([6 3],1);
elseif (Lane == 8)
    car.position.x = xb4 ;
    car.position.y = yb2 + 9*laneWidth/2;
    car.heading = pi;
    car.DestinationLane = datasample([2],1);
elseif (Lane == 9)
    car.position.x = xb4 ;
    car.position.y = yb2 + 11*laneWidth/2;
    car.heading = pi;
    car.DestinationLane = datasample([1 10],1);
elseif (Lane == 10)
    car.position.x = xb2 + 5*laneWidth/2;
    car.position.y = yb4 ;
    car.heading = 3*pi/2;
    car.DestinationLane = datasample([9 6],1);
elseif (Lane == 11)
    car.position.x = xb2 + 3*laneWidth/2;
    car.position.y = yb4 ;
    car.heading = 3*pi/2;
    car.DestinationLane = datasample([5],1);
elseif (Lane == 12)
    car.position.x = xb2 + 1*laneWidth/2;
    car.position.y = yb4 ;
    car.heading = 3*pi/2;
    car.DestinationLane = datasample([1 4],1);
end
car.phiref = car.heading;