function drawBox(xx,yy,z,color)
hold on
xx(end)=[];
yy(end)=[];
% x = [1 4 4 0 1];
% y = [0 0 3 3 0];
% z = 2;
zz = [0 0 0 0];
% line(xx,yy,zz,'Color',color)
% line(xx,yy,zz+z,'Color',color)
% for i = 1:4
%     line([xx(i) xx(i)],[yy(i) yy(i)], [0 z],'Color',color)
% end
% view(3)
fill3(xx,yy,zz,color)
fill3(xx,yy,zz+z,color)
fill3([xx(1) xx(4) xx(4) xx(1)],[yy(1) yy(4) yy(4) yy(1)], [0 0 z z],color)
fill3([xx(1) xx(2) xx(2) xx(1)],[yy(1) yy(2) yy(2) yy(1)], [0 0 z z],color)
fill3([xx(2) xx(3) xx(3) xx(2)],[yy(2) yy(3) yy(3) yy(2)], [0 0 z z],color)
fill3([xx(3) xx(4) xx(4) xx(3)],[yy(3) yy(4) yy(4) yy(3)], [0 0 z z],color)