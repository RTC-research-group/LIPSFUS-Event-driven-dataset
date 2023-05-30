function tj=sn(ti,w,sign,snmp,simp,eta0,delay)

eval('eta0;','eta0=snmp.eta0;');
[numNeuron,numSynapses]=size(w);

eval('delay;','delay=repmat(snmp.delay0,numNeuron,1);');


pspFcn  = snmp.pspFcn;
refFcn  = snmp.refFcn;
tau     = snmp.tau;
numSO   = snmp.numSO;
tau_r   = snmp.tau_r;
theta   = snmp.threshold;
spike   = snmp.spike;
Tabs    = snmp.Tabs;
Uabs    = snmp.Uabs;
sm      = simp.sm;

t=0:simp.timestep:simp.timerange;
tj=[];
tr=length(t);

w=w.*repmat(sign,1,numSynapses);
Ti=cell(1,numNeuron);
Wi=cell(1,numNeuron);
for iNeuron=1:numNeuron
    for iSpike=1:length(ti{iNeuron})
        if ti{iNeuron}(iSpike)~=inf
            Ti{iNeuron}=[Ti{iNeuron} ti{iNeuron}(iSpike)+delay(iNeuron,:)];
            Wi{iNeuron}=[Wi{iNeuron} w(iNeuron,:)];
        end
    end
end
T=cell2mat(Ti);
[T,Idx]=sort(T,'ascend');
W=cell2mat(Wi);
W=W(Idx);
numS=length(T);

switch sm        
    case 'ts'
        
        
        u=zeros(numS,tr);
% uncomment to reset to default        for iS=2:numS
        for iS=1:numS

%             u(1,:)=0;
%             E_L=-70;
%             R_m=10;
%              I_e_vect(iS)=0.55;
            u(iS,:)=W(iS)*feval(pspFcn,t-T(iS),tau,T(iS),[],0);
           
%             dV = u(iS-1,:)+(((t-T(iS))/tau).*(E_L-u(iS-1,:)+I_e_vect(iS).*R_m));
%             u(iS,:)=W(iS)*dV;
        end
        x=sum(u,1);
        t_StimEnd=size(x);
        Ix=x/(max(x));
        [x1,y1,s1]=LIF_input_fixed_function(Ix,0, t_StimEnd(2), theta);
%         
        if spike==1
             tj=s1(1)/10;
%             f=find(x>=theta,1,'first');
%             if ~isempty(f)
%                 tj=t(f);
%             end
        else
         
            f=0; s=0; jSpike=1;eta=0;
            while ~isempty(f) && s<tr
                f=find(x(s+1:end)>theta,1,'first');
                if ~isempty(f)
                    tj(jSpike)=t(s+f);
                    I=find(T<tj(jSpike),1,'last');
                    for i=1:I 
                        u(i,:)=W(i)*feval(pspFcn,t'-T(i),tau,repmat(T(i),tr,1),tj',numSO);
                    end
                    eta=eta+feval(refFcn,t-tj(jSpike),tau_r,eta0,Tabs,Uabs);
                    x=sum(u,1)+eta;
                    jSpike=jSpike+1;
                    s=s+f;
                end
            end
        end
end




