function r=PDalfaFcn1(t,tau,varargin)


r=exp(1-t./tau).*(1-t./tau)./tau;
r(t<0)=0;     % r=e/tau  at t=0
