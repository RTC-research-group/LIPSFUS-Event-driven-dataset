function r=PDref1(t,tau,eta0,varargin)



r=eta0./tau.*exp(-t./tau);
r(t<=0)=0;