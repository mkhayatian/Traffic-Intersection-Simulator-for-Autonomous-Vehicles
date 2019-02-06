% traffic light
clc;close all;clear all;
rng(4444); 
h=0.01;tf=5;
t=0:h:tf;
N=length(t);
ts = rand(4,100);

timer1=30; % timer on time
timer2=30;
for i = 1:N
    time =i*h;
    if time>ts(1)
        ts=ts(2:end);
        road=randi(4);
        if road == 1 
            x =
end


