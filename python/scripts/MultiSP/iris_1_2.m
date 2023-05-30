% % XOR demo
% clear all
% close all
% clc
% 
% % out=transpose(csvread('wisconsin_in.csv', 1,1));
% % % out=transpose(csvread('xorin.csv', 400,7));
% % % out=transpose(csvread('HouseVotes84.csv', 400,8));
% % % % % % % % % % % % % % % % % % % % % % % % [x1,y1,t1]=LIF_input_fixed_function(file(:,1),t_StimStart, t_StimEnd)
% % ti= num2cell(out,3)
% % td=transpose(csvread('wisconsin_out.csv', 1,2));
% 
% % 
% % % ti=[{[0];[0];[1];[0];[0];[1];[0];[0];[1]} {[0];[0];[1];[0];[0];[1];[0];[0];[1]} {[0];[1];[0];[0];[0];[1];[0];[1];[0]} {[0];[1];[1];[0];[1];[0];[0];[1];[1]}];
% % % td=transpose(csvread('HouseVotes841.csv', 400,16));
% % % td=transpose(csvread('xorout.csv', 400,3));
% file=csvread('iris_in_1.csv', 1,1);
% % file=csvread('wisconsin_half_2.csv', 1,1);
% t_StimStart=0;
% a=size(file);
% t_StimEnd= a(:,1);
% % file=transpose(file)
% theta= 40;
% for i=1:4
% [x(:,i),y(:,i)]=LIF_input_fixed_function_discrete(file(:,i),t_StimStart, t_StimEnd,theta);
% end
% ti= transpose(num2cell(y,3));
% td=transpose(csvread('iris_out_1.csv', 1,1));
% % td=transpose(csvread('wisconsin_half_out_2.csv', 1,2));
% % td=[2 3 4 5;2 4 6 8;1 3 5 7];
% % net=newsnn([9 8 3],1:3,[0 3 0],'wim1');
% 
% net=newsnn([4 8 1],1:10,[0 3 0],'wim1');
% 
% net.snmParam.pspFcn='alfaFcn1';
% net.snmParam.tau=15;
% net.snmParam.threshold=45;
% net.simParam.timestep=0.1;
% net.simParam.timerange=50;  
% net.trainParam.goal=1;    
% net.trainParam.epochs=150;
% net.trainParam.lr=1;
% 
% [net,tr]=trainsnn(net,ti,td);
% epoch=tr.epoch(end);
% perf=tr.perf(end);
% ta=simsnn(net,{[0];[0];[6];[0];[6];[6];[0];[6];[6];[6]});
% 
% % --------步数和均方误差的关系------- %
% plot(tr.epoch,tr.perf);
% xlabel('epoch');
% ylabel('MSE');
% title('epoch and perf');
% grid on;
% % Testing!!!!!!!!!!!!!!!!

Test_file=csvread('iris_in_2.csv', 1,1);
Test_ti= transpose(num2cell(Test_file,3));
test_td=transpose(csvread('iris_out_2.csv', 1,1));

a=size(Test_file);
Train_size= a(:,1);
for t=1:Train_size
ta=simsnn(net,Test_ti(:,t));
out([t])=ta(3);
B = [out{:}];
output= transpose(cell2mat(B));
 if output(t)<16
    result(t)=0;
 elseif  output(t)>16 &&  output(t)<=17.5
        result(t)=1;
     else
    result(t)=2;
 end

end
transpose(result)