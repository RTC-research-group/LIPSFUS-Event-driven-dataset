function r=alfaFcn1(t,tau,varargin)
% calculate spike response function
%
% INPUT
%   t   - input time point, time vector or time matrix
%   tau - The membrance potential decay time constant
% 
% OUTPUT
%   r   - Results
%
r=t./tau.*exp(1-t./tau);
r(t<=0)=0;