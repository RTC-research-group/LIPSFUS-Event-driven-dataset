function R=PDu_t(t,tj,prej,sign,w,snmp,eta0,delay)



eval('eta0;','eta0=snmp.eta0;')
numNeuron=length(prej);
eval('delay;','delay=repmat(snmp.delay0,numNeuron,1);')


tau     = snmp.tau;
tau_r   = snmp.tau_r;
Tabs    = snmp.Tabs;
Uabs    = snmp.Uabs;
numSO   = snmp.numSO;
PDpspFcn= ['PD' snmp.pspFcn];
PDrefFcn= ['PD' snmp.refFcn];
tr=length(t);



Ti=cell(1,numNeuron);
Wi=cell(1,numNeuron);
for iNeuron=1:numNeuron
    for iSpike=1:length(prej{iNeuron})
        if prej{iNeuron}(iSpike)~=inf
            Ti{iNeuron}=[Ti{iNeuron} prej{iNeuron}(iSpike)+delay(iNeuron,:)];
            Wi{iNeuron}=[Wi{iNeuron} w(iNeuron,:)*sign(iNeuron)];
        end
    end
end
T=cell2mat(Ti);
W=cell2mat(Wi);
numT=length(T);
T=repmat(T',1,tr);
s=repmat(t,numT,1)-T;
s=s(:);
T=T(:);
R=zeros(size(s));
I=find(s>0);
R(I)=feval(PDpspFcn,s(I),tau,T(I),tj',numSO);
R=reshape(R,numT,tr);
R=W*R;


temp=feval(PDrefFcn,repmat(t,length(tj),1)-repmat(tj',1,tr),tau_r,eta0,Tabs,Uabs);
R=R+sum(temp,1);

