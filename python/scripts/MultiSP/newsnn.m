function net=newsnn(s,delay,numIPSP,initWeights,seed)



if nargin<2
  disp('Lack network information.')
end

if nargin<3, numIPSP=zeros(size(s)); end    
if nargin<4, initWeights='wim1'; end        
if nargin<5, seed=[]; end                    

numLayers=length(s);
numSynapses=length(delay);
numEPSP=s-numIPSP;


net.size=s;                     
net.numIPSP=numIPSP;            
net.numLayers=numLayers;                   
net.numSynapses=numSynapses;    
for iLayer=1:numLayers 
    net.sign{iLayer}=...       
        [ones(numEPSP(iLayer),1);-ones(numIPSP(iLayer),1)];    
end



net.snmParam.pspFcn='alfaFcn1'; 
net.snmParam.refFcn='ref1';    
net.snmParam.tau=7;             
net.snmParam.numSO=0;
net.snmParam.tau_r=10;         
net.snmParam.eta0=1;            
net.snmParam.Tabs=0;            
net.snmParam.Uabs=0;            
net.snmParam.threshold=50;
net.snmParam.delay0=delay;      
net.snmParam.spike=1;           
                                

net.simParam.sm='ts';           
net.simParam.timestep=0.1;      
net.simParam.timerange=150;     


net.trainParam.epochs=100;          
net.trainParam.goal=0;              
net.trainParam.lr=1;                
net.trainParam.lr_gamma=0;          
net.trainParam.lr_delay=0;          
net.trainParam.show=1;             
net.trainParam.max_fail=5;          
net.trainParam.negWeights=false;    
                                    


net.initFcn=repmat({initWeights},1,numLayers-1);
net.initseed=seed;
net=initsnn(net);







