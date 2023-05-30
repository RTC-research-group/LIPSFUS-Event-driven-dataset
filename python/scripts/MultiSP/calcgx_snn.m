function [gW,gW_sum,gGamma_sum,gDelay_sum]=calcgx_snn(net,td,ta,w,delay)



if nargin<5
    delay=cell2mat_snn(net.snmParam.delay);
    if nargin<4
        w=getx_snn(net);
    end
end



tau         = net.snmParam.tau;
numSO       = net.snmParam.numSO;
tau_r       = net.snmParam.tau_r;
gamma       = net.snmParam.gamma;
pspFcn      = net.snmParam.pspFcn;
refFcn      = net.snmParam.refFcn;
Tabs        = net.snmParam.Tabs;
Uabs        = net.snmParam.Uabs;
numSynapses = net.numSynapses;
numLayers   = net.numLayers;
s           = net.size;
sign        = net.sign;
numInputs=size(td,2);
PDpspFcn=['PD' pspFcn];
PDrefFcn=['PD' refFcn];
PDrefFcn_gamma=[PDrefFcn '_gamma'];


gW=cell(numInputs,1);
gW_sum=zeros(s(1:end-1)*(s(2:end))',numSynapses);
gGamma=cell(numInputs,1);
gGamma_sum=zeros(sum(s(2:end)),1);
gDelay=cell(numInputs,1);
gDelay_sum=zeros(size(gW_sum));
c0 = clock;
for iInput=1:numInputs
    Ta=ta(iInput,:);
    
    for iNeuron=1:s(numLayers)
        Ta{numLayers}{iNeuron}=Ta{numLayers}{iNeuron}(1);
    end

    Nspike=cell(1,numLayers);
    for iLayer=1:numLayers
        for iNeuron=1:s(iLayer)
            Nspike{iLayer}=[Nspike{iLayer} length(Ta{iLayer}{iNeuron})];
        end
    end

    
    pdu_t=[];
    sp=1;
    for iLayer=2:numLayers
        PreiLayer=iLayer-1;
        for iNeuron=1:s(iLayer)
            pren=sp:(sp+s(PreiLayer)-1);
            pdu_t{iLayer}{iNeuron}=max(0.1,PDu_t(Ta{iLayer}{iNeuron},Ta{iLayer}{iNeuron},Ta{PreiLayer},...
                sign{PreiLayer},w(pren,:),net.snmParam,gamma{iLayer}(iNeuron),delay(pren,:)));
            sp=sp+s(PreiLayer);
        end
    end

    
    pdE_t=(cell2mat(Ta{numLayers})-td(:,iInput))';
    sp=size(w,1)-s(numLayers-1)*s(numLayers);
    for iLayer=numLayers-1:-1:2
        PostiLayer=iLayer+1;
        temp2=[];
        for iPostNeuron=1:s(PostiLayer)
            SO=Ta{PostiLayer}{iPostNeuron}';
            NSO=length(SO);
            SI=cell2mat((Ta{iLayer})');
            NSI=length(SI);
            newSI=repmat(SI,NSO,1);
            newSI=newSI(:);
            newWD=[];
            for iNeuron=1:s(iLayer)
                Idx=sp+(iPostNeuron-1)*s(iLayer)+iNeuron;
                newWD=[newWD;repmat([w(Idx,:)*sign{iLayer}(iNeuron) delay(Idx,:)],...
                    Nspike{iLayer}(iNeuron)*NSO,1)];
            end
            newW=newWD(:,1:numSynapses);
            newD=newWD(:,numSynapses+1:end);
            si=repmat(newSI,1,numSynapses)+newD;
            si=si(:);
            newSO=repmat(SO,NSI,numSynapses);
            newSO=newSO(:);
            temp=feval(PDpspFcn,newSO-si,tau,si,SO,numSO);
            temp=reshape(temp,NSO*NSI,numSynapses);
            temp=newW.*temp;
            temp=reshape(sum(temp,2),NSO,NSI);
            temp=temp./repmat((pdu_t{PostiLayer}{iPostNeuron})',1,NSI);
            temp2=[temp2;temp];
        end
        pdE_t=[pdE_t(1:sum(Nspike{PostiLayer}))*temp2 pdE_t];
        sp=sp-s(iLayer-1)*s(iLayer);
    end

    if net.trainParam.lr
  
        
    pdt_w=[];
    sp=0;
    for iLayer=2:numLayers
        PreiLayer=iLayer-1;
        for iNeuron=1:s(iLayer)
            SO=Ta{iLayer}{iNeuron}';
            NSO=length(SO);
            SI=cell2mat((Ta{PreiLayer})');
            NSI=length(SI);
            newD=[];
            for iPreNeuron=1:s(PreiLayer)
                temp=repmat(delay(sp+(iNeuron-1)*s(PreiLayer)+iPreNeuron,:),NSO,1);
                temp=temp(:);
                newD=[newD repmat(temp,1,Nspike{PreiLayer}(iPreNeuron))];
            end
            si=newD+repmat(SI,NSO*numSynapses,1);
            si=si(:);
            newSO=repmat(SO,numSynapses,NSI);
            newSO=newSO(:);
            temp=feval(pspFcn,newSO-si,tau,si,SO,numSO);
            temp=reshape(temp,NSO*numSynapses,NSI);
            temp=mat2cell(temp,NSO*numSynapses,Nspike{PreiLayer});
            for iPreNeuron=1:s(PreiLayer)
                temp2=reshape(sum(temp{iPreNeuron},2),NSO,numSynapses);
                for iSpike=1:NSO
                    temp2(iSpike,:)=...
                        ((feval(PDrefFcn,SO(iSpike)-SO,tau_r,gamma{iLayer}(iNeuron),Tabs,Uabs))'*temp2-...
                        sign{PreiLayer}(iPreNeuron)*temp2(iSpike,:))/...
                        pdu_t{iLayer}{iNeuron}(iSpike);
                end
                pdt_w{PreiLayer,iLayer}{iPreNeuron,iNeuron}=temp2;
            end
        end
        sp=sp+s(PreiLayer)*s(iLayer);
    end


    
    sp=1;
    for iLayer=2:numLayers
        for iNeuron=1:s(iLayer)
            for iPreNeuron=1:s(iLayer-1)
                gW{iInput}=[gW{iInput};pdE_t(sp:sp+Nspike{iLayer}(iNeuron)-1)*...
                    pdt_w{iLayer-1,iLayer}{iPreNeuron,iNeuron}];
            end
            sp=sp+Nspike{iLayer}(iNeuron);
        end
    end
    gW_sum=gW_sum+gW{iInput};
    end

   
    if net.trainParam.lr_gamma
        sp=1;
       
        for iLayer=2:numLayers
            for iNeuron=1:s(iLayer)
                SO=Ta{iLayer}{iNeuron};
                NSO=length(SO);
                temp=feval(PDrefFcn_gamma,repmat(SO',1,NSO)-repmat(SO,NSO,1),tau_r,Tabs,Uabs);
                temp2=sum(temp,2);
                for iSpike=2:NSO
                    temp2(iSpike)=(feval(PDrefFcn,SO(iSpike)-SO,tau_r,gamma{iLayer}(iNeuron),Tabs,Uabs)*temp2-...
                        temp2(iSpike))/pdu_t{iLayer}{iNeuron}(iSpike);
                end
                gGamma{iInput}=[gGamma{iInput};pdE_t(sp:sp+Nspike{iLayer}(iNeuron)-1)*temp2];
                sp=sp+Nspike{iLayer}(iNeuron);
            end
        end
        gGamma_sum=gGamma_sum+gGamma{iInput};
    end

    
    if net.trainParam.lr_delay
        
        pdt_d=[];
        sp=0;
        for iLayer=2:numLayers
            PreiLayer=iLayer-1;
            for iNeuron=1:s(iLayer)
                SO=Ta{iLayer}{iNeuron}';
                NSO=length(SO);
                SI=cell2mat((Ta{PreiLayer})');
                NSI=length(SI);
                newD=[];
                newW=[];
                for iPreNeuron=1:s(PreiLayer)
                    Idx=sp+(iNeuron-1)*s(PreiLayer)+iPreNeuron;
                    temp=repmat(delay(Idx,:),NSO,1);
                    temp=temp(:);
                    newD=[newD repmat(temp,1,Nspike{PreiLayer}(iPreNeuron))];
                    temp=repmat(w(Idx,:)*sign{PreiLayer}(iPreNeuron),NSO,1);
                    temp=temp(:);
                    newW=[newW repmat(temp,1,Nspike{PreiLayer}(iPreNeuron))];
                end
                si=newD+repmat(SI,NSO*numSynapses,1);
                si=si(:);
                newSO=repmat(SO,numSynapses,NSI);
                newSO=newSO(:);
                temp=feval(PDpspFcn,newSO-si,tau,si,SO,numSO);
                temp=reshape(temp,NSO*numSynapses,NSI);
                temp=mat2cell(newW.*temp,NSO*numSynapses,Nspike{PreiLayer});
                for iPreNeuron=1:s(PreiLayer)
                    temp2=reshape(sum(temp{iPreNeuron},2),NSO,numSynapses);
                    for iSpike=1:NSO
                        temp2(iSpike,:)=...
                            ((feval(PDrefFcn,SO(iSpike)-SO,tau_r,gamma{iLayer}(iNeuron),Tabs,Uabs))'*...
                            temp2+temp2(iSpike,:))/pdu_t{iLayer}{iNeuron}(iSpike);
                    end
                    pdt_d{PreiLayer,iLayer}{iPreNeuron,iNeuron}=temp2;
                end
            end
            sp=sp+s(PreiLayer)*s(iLayer);
        end

 
        
        sp=1;
        for iLayer=2:numLayers
            for iNeuron=1:s(iLayer)
                for iPreNeuron=1:s(iLayer-1)
                    gDelay{iInput}=[gDelay{iInput};pdE_t(sp:sp+Nspike{iLayer}(iNeuron)-1)*...
                        pdt_d{iLayer-1,iLayer}{iPreNeuron,iNeuron}];
                end
                sp=sp+Nspike{iLayer}(iNeuron);
            end
        end
        gDelay_sum=gDelay_sum+gDelay{iInput};
    end
    c = clock;
    elapsed_time_min = (c(4)*60+c(5)+c(6)/60) - (c0(4)*60+c0(5)+c0(6)/60);
    c0=c;
    
    if (~rem(iInput,50))
       fprintf('Processing Input calcgx: %d/%d. Last Input processing time: %d minutes\n',iInput,numInputs,elapsed_time_min)
    end


end
