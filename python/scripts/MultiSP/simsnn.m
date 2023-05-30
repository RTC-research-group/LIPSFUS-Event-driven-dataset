function [ta,noFire,w]=simsnn(net,ti,w,delay)

if nargin<4
    delay=cell2mat_snn(net.snmParam.delay);
    if nargin<3
        w=getx_snn(net);
    end
end
noFire=false;
%ta=cell(numInputs,net.numLayers);
ta{1}=ti;

snmParam=net.snmParam;
gamma=net.snmParam.gamma;
s=net.size;
sp=1;
for iLayer=2:net.numLayers 
    PreiLayer=iLayer-1;
    if iLayer==net.numLayers
        snmParam.spike=1;
    end
    
    for iNeuron=1:s(iLayer) 
        
        pren=sp:(sp+s(PreiLayer)-1);
        while 1
            ta{iLayer}{iNeuron,1}=sn(ta{PreiLayer},w(pren,:),...
                net.sign{PreiLayer},snmParam,net.simParam,gamma{iLayer}(iNeuron),delay(pren,:));
            if isempty(ta{iLayer}{iNeuron})
                temp1=w(pren,:);
                temp2=repmat(net.sign{PreiLayer},1,net.numSynapses).*temp1;
                temp1=(temp2>0).*temp1*1.05+(temp2<0).*temp1*0.95;
                w(pren,:)=temp1;
            else
                break
            end
        end
        sp=sp+s(PreiLayer);
    end
end