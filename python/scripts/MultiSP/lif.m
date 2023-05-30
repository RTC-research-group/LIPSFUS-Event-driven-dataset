%Leaky Integrate-and-Fire Neuron Simulation
%INPUT- current, input current waveform, with units in mA
%       threshold, spiking threshold in mV 
%       tau, time constant in seconds (=RC)
%       R, membrane resistance in ohms
%       fs, sampling rate (Hz)
%OUTPUT- voltage, resulting membrane voltage in mV
%        spikes, resulting spike times in S
function [voltage, spikes]=lif(current,threshold,tau,R,fs)
    %implement tau dv/dt = RI(t)- (V(t)-Vrest)
    %tau s V(s) = R I(s)-(V(s)-Vrest)
    % V(s)(1+tau s)=RI(s)+Vrest
    % V(s) = (RI(s)+Vrest)/(1+tau s)
    voltage = zeros(size(current));
    spikes=[];
    Vrest = -65;%initial voltage level
    a1 = exp(-1/(tau*fs)); %transform pole of RC circuit from s to Z domain
    voltage(1)=Vrest;
    for i_time = 2:1:length(voltage)
        voltage(i_time)=a1*(voltage(i_time-1))+R*(1-a1)*current(i_time)+(1-a1)*Vrest;
        if(voltage(i_time)>=threshold) %fire a spike
            spikes = [spikes,i_time/fs];
            voltage(i_time)=Vrest; %reset
        end
    end
end