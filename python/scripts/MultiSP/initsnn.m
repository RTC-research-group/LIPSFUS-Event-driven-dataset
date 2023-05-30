function net=initsnn(net)

initFcn=net.initFcn;
seed=net.initseed;
numLayers=net.numLayers;
numSynapses=net.numSynapses;
s=net.size;


if ~isempty(seed), rand('state',seed); end
for iLayer=1:numLayers-1
    PostiLayer=iLayer+1;
    for iPreNeuron=1:s(iLayer)
        for iPostNeuron=1:s(PostiLayer)
            switch initFcn{iLayer}
                case 'wim1'
                    net.w{iLayer,PostiLayer}{iPreNeuron,iPostNeuron}=rand(1,numSynapses)*9+1;
               
                    
                
                otherwise   
                    net.w{iLayer,PostiLayer}{iPreNeuron,iPostNeuron}=eval(initFcn{iLayer});
            end 
            net.snmParam.delay{iLayer,PostiLayer}{iPreNeuron,iPostNeuron}=net.snmParam.delay0;
        end
    end
    net.snmParam.gamma{PostiLayer,1}=net.snmParam.eta0*ones(s(PostiLayer),1);
end
    
