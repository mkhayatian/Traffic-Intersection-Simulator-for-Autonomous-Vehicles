clc;clear all;close all;
x(1) = 0;
y(1) = 5;
phi(1) = 0;
x1(1)=0;
y1(1)=0;
phi1(1)=0;
h=0.01;
v = 10;
v1 = 8;
L = 3;
sai = 0;
sai1=0;
yr = 5*ones(1,1000);
eSAIDER = 0;

for i = 1:10000
    t(i)= i*h;
    if i>1000
        yr(i) = 0;
    end
    eSAI(i) = yr(i)-y(i);
    if i>1
        eSAIDER = eSAI(i) - eSAI(i-1); 
    end
    sai(i) = 0.01 * eSAI(i) + 10 * eSAIDER;
    if sai(i) > 0.6
        sai(i) = 0.6;
    end
    if sai(i) < -0.6
        sai(i) = -0.6;
    end
    x(i+1) = x(i) + h * (v .* cos( phi(i) ));
    y(i+1) = y(i) + h * (v .* sin( phi(i) ));
    phi(i+1) = phi(i) + h * ((v / L) .* tan( sai(i) ));
    
    x1(i+1) = x1(i) + h * (v1 .* cos( phi1(i) ));
    y1(i+1) = y1(i) + h * (v1 .* sin( phi1(i) ));
    phi1(i+1) = phi1(i) + h * ((v1 / L) .* tan( sai1 ));    
end
x(end)=[];y(end)=[];phi(end)=[];x1(end)=[];y1(end)=[];phi1(end)=[];
plot3(x,y,t)
hold
plot3(x1,y1,t)
grid on