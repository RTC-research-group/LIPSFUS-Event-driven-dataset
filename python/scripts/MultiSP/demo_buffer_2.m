% XOR demo
clear all
close all
clc

file=csvread('buffer_level_22_in.csv', 1,1);
t_StimStart=0;
a=size(file);
t_StimEnd= a(:,1);
theta= 40;
for i=1:5
[x(:,i),y(:,i)]=LIF_input_fixed_function_discrete(file(:,i),t_StimStart, t_StimEnd,theta);
end
ti= transpose(num2cell(y,3));
td=transpose(csvread('buffer_level_22_out.csv', 1,8));

net=newsnn([5 5 1],1:15,[0 1 0],'wim1');

net.snmParam.pspFcn='alfaFcn1';
net.snmParam.tau=7;
net.snmParam.threshold=40;
net.simParam.timestep=0.1;
net.simParam.timerange=50;  
net.trainParam.goal=0.2;    
net.trainParam.epochs=40;
net.trainParam.lr=1;
[net,tr]=trainsnn(net,ti,td);
epoch=tr.epoch(end);
perf=tr.perf(end);
% ta=simsnn(net,{[0];[0];[6];[0];[6];[6]});

% % --------??????????------- %
% plot(tr.epoch,tr.perf);
% xlabel('epoch');
% ylabel('MSE');
% title('epoch and perf');
% grid on;
% % % Testing!!!!!!!!!!!!!!!!
% 
% Test_file=csvread('buffer_level_22_in.csv', 1,1);
% Test_ti= transpose(num2cell(Test_file,3));
% test_td=transpose(csvread('buffer_level_22_out.csv', 1,8));
% 
% a=size(Test_file);
% Train_size= a(:,1);
% for t=1:Train_size
% ta=simsnn(net,Test_ti(:,t));
% out([t])=ta(3);
% B = [out{:}];
% output= transpose(cell2mat(B));
% if output(t)<17
%     result(t)=15;
% elseif output(t)>=17 && output(t)<=18.5
%     result(t)=17;
%     elseif output(t)>18.5 && output(t)<20
%     result(t)=19;
% else output(t)>20
%     result(t)=21;
% end
% end
% transpose(result);