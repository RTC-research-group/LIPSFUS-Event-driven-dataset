% XOR demo
clear all
close all
clc

out=transpose(csvread('HouseVotes84.csv', 400,8));
ti= num2cell(out,3)
% ti=[{[0];[0];[1];[0];[0];[1];[0];[0];[1]} {[0];[0];[1];[0];[0];[1];[0];[0];[1]} {[0];[1];[0];[0];[0];[1];[0];[1];[0]} {[0];[1];[1];[0];[1];[0];[0];[1];[1]}];
td=transpose(csvread('HouseVotes84.csv', 400,14));
% td=[2 3 4 5;2 4 6 8;1 3 5 7];

net=newsnn([9 8 3],1:16,[0 1 0],'wim1');

net.snmParam.pspFcn='alfaFcn1';
net.snmParam.tau=7;
net.snmParam.threshold=40;
net.simParam.timestep=0.1;
net.simParam.timerange=50; 
net.trainParam.goal=1;    
net.trainParam.epochs=150;
net.trainParam.lr=1;

[net,tr]=trainsnn(net,ti,td);
epoch=tr.epoch(end);
perf=tr.perf(end);

ta=simsnn(net,{[0];[0];[1];[0];[1];[1];[0];[1];[1]});
% --------步数和均方误差的关系------- %
plot(tr.epoch,tr.perf);
xlabel('epoch');
ylabel('MSE');
title('epoch and perf');
grid on;