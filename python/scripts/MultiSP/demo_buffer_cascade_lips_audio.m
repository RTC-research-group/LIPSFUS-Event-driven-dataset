% % % buffer demo cascade
clear all 
close all 
clc 
%%%%%%%%%%%%%%%%%%%% SNN Training %%%%%%%%%%%%%%%%%%%%%%%%%%
file=transpose(csvread('ds\\dataset_audio_lips_128ch_in_600_train.csv', 0,0)); %% input to SNN 
ti= num2cell(file,3);
td=transpose(csvread('ds\\dataset_audio_lips_128ch_out_600_train.csv', 0,64));  %% expected output (supervised learning)
net=newsnn([64 100 10 1],1:10,[0 5 0],'wim1');
net.snmParam.pspFcn='alfaFcn1'; 
net.snmParam.tau=3;                                   %% membrane time constant  
net.snmParam.threshold=35; 
net.simParam.timestep=0.1;                            %% time step to encode SNN  
net.simParam.timerange=400;                            %% maximum time to rum code 
net.trainParam.goal=0.1;                              %% Mean Square Error 
net.trainParam.epochs=10;                              %% Number of training iterations to achieve desire traininf MSE
net.trainParam.lr=1;
[net,tr]=trainsnn(net,ti,td); 
epoch=tr.epoch(end); 
perf=tr.perf(end); 
plot(tr.epoch,tr.perf); 
xlabel('epoch');
ylabel('MSE'); 
title('epoch and perf'); 
 grid on; 

%%%%%%%%%%%%%%%%%%%%%% Testing and Validation %%%%%%%%%%%%%%%%%%%%%%%%

% use following line to pass input to validate output 
% % % % ta=simsnn(net,{[0];[0];[6];[0];[6];[6]});   

% use following code to read file for validation 
wg=getx_snn(net);
wg=wg*1000;
Test_file=csvread('ds\\dataset_audio_lips_128ch_in_51_val.csv', 0,0);  %% input to SNN 
Test_ti= transpose(num2cell(Test_file,3));
test_td=csvread('ds\\dataset_audio_lips_128ch_out_51_val.csv', 0,64);   %% desire output 
a=size(Test_file);
Train_size= a(:,1);
for t=1:Train_size
ta=simsnn(net,Test_ti(:,t));
out([t])=ta(4);
B = [out{:}];  
output= transpose(cell2mat(B));                   %% SNN output
end
