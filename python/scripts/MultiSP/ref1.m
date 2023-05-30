function r=ref1(t,tau,eta0,varargin)
% Calculate refractoriness

r=-eta0.*exp(-t./tau);
r(t<=0)=0;