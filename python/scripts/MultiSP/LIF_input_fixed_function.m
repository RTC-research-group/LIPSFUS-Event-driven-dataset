    
function [x1,y1,t1]=LIF_input_fixed_function(I_in,t_StimStart, t_StimEnd, theta)
    j=1;
    t_spike=0;
    time=0;
    refr=0;
    dt = 1; %time step [ms] 
    t_end = t_StimEnd; %total time of run [ms] 
%     t_StimStart = 100;  %time to start injecting current [ms] 
%     t_StimEnd = 400; %time to end injecting current [ms] 
    E_L = -70; %resting membrane potential [mV] 
    V_th = -theta;  %spike threshold [mV] 
    V_th_e = -60;  %spike threshold [mV] 
    V_th_i = -90;  %spike threshold [mV] 
    V_reset = -75; %value to reset voltage to after a spike [mV] 
    V_spike_e = 20; %value to draw a spike to, when cell spikes [mV] 
    V_spike = 20;
    V_spike_i = -110; %value to draw a spike to, when cell spikes [mV] 
    R_m =50; %membrane resistance [MOhm] 
    tau = 10; %membrane time constant [ms]
    %DEFINE INITIAL VALUES AND VECTORS TO HOLD RESULTS 
    t_vect = 0:dt:t_end; %will hold vector of times 
    V_vect = zeros(1,length(t_vect)); %initialize the voltage vector                                               
    %initializing vectors makes your code run faster! 
    V_plot_vect = zeros(1,length(t_vect)); %pretty version of V_vect to be plotted, that displays a spike                        
    % whenever voltage reaches threshold 
    i = 1;   % index denoting which element of V is being assigned 
    V_vect(i)= E_L;  %first element of V, i.e. value of V at t=0 
    V_plot_vect(i) = V_vect(i);  %if no spike, then just plot the actual voltage V   
    
    NumSpikes = 0; %holds number of spikes that have occurred 
    
    
    for t=dt:dt:t_end   %loop through values of t in steps of dt ms       
       if NumSpikes<1 
        V_inf = E_L + I_in(i)*R_m;  %value that V_vect is exponentially                                       
        %decaying towards at this time step         %next line does the integration update rule     
        V_vect(i+1) = V_inf + (V_vect(i) - V_inf)*exp(-dt/tau);      %if statement below says what to do if voltage crosses threshold     
        if (V_vect(i+1) > V_th)  %cell spiked         
            V_vect(i+1) = V_reset;    %set voltage back to V_reset         
            V_plot_vect(i+1) = V_spike; %set vector that will be plotted to show a spike here         
            NumSpikes = NumSpikes + 1; %add 1 to the total spike count 
            t_spike(j) = i;
            j=j+1;
        else   %voltage didn't cross threshold so cell does not spike        
            V_plot_vect(i+1) = V_vect(i+1); %plot the actual voltage     
        end
        i = i + 1;  %add 1 to index, corresponding to moving forward 1 time step 
      
       else 
           V_plot_vect(i+1)= V_reset;
           V_vect(i+1)=V_reset;
           i = i + 1;
       end
       
       end
    y1=V_plot_vect;
    t1=t_spike;
    x1=V_vect;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     for t=dt:dt:t_end  %loop through values of t in steps of dt ms    
%        if t> t_StimStart && t< t_StimEnd
%            I_Stim= I_in(i);
% %             dV =(dt/tau).*(E_L-V_vect(i)+I_Stim.*R_m);
% %         V_vect(i+1) = V_vect(i) + dV;
%         V_inf = E_L + I_Stim*R_m;  %value that V_vect is exponentially                                       
%         %decaying towards at this time step         %next line does the integration update rule     
%         V_vect(i+1) = V_inf + (V_vect(i) - V_inf)*exp(-dt/tau);      %if statement below says what to do if voltage crosses threshold     
%         if (i>(time+refr) && (V_vect(i+1) > V_th_e  || V_vect(i+1) < V_th_i))  %cell spiked  %(V_vect(i+1) > V_th_e  || V_vect(i+1) < V_th_i)
%             
%             if (V_vect(i+1) > V_th_e)
%                 V_plot_vect(i+1) = V_spike_e;    %set voltage back to V_reset 
%                
%             elseif(V_vect(i+1) < V_th_i)
%                
%                 V_plot_vect(i+1) = V_spike_i;               
%             end
%             t_spike(j) = i;    % record spike
%             time=i;
%             refr=10;
%             j=j+1;
%             V_vect(i+1) = V_reset;
% %             V_plot_vect(i+1) = V_spike; %set vector that will be plotted to show a spike here         
%             NumSpikes = NumSpikes + 1; %add 1 to the total spike count     
%         else   %voltage didn't cross threshold so cell does not spike        
%             V_plot_vect(i+1) = V_reset; %plot the actual voltage     
%         end
%        else
%             V_vect(i+1) = V_reset;
%             V_plot_vect(i+1) = V_reset;
%        end
%         i = i + 1;  %add 1 to index, corresponding to moving forward 1 time step 
%     end
%     x1=t_vect;
% %     x1= V_vect;
%     y1=transpose(V_plot_vect);
%     t1=t_spike;
% %         AveRate = 1000*NumSpikes/(t_StimEnd - t_StimStart) %gives average firing rate in [#/sec = Hz]     
% %         %MAKE PLOTS 
% %         figure
% %         subplot(2,1,1);
% %         plot(t_vect, V_plot_vect);   
% %         title('Voltage vs. time'); 
% %         xlabel('Time in ms'); 
% %         ylabel('Voltage in mV'); 
% %         subplot(2,1,2);
% %         plot(t_vect,  V_vect);   
% %         title('Voltage vs. time'); 
% %         xlabel('Time in ms'); 
% %         ylabel('Voltage in mV'); 
%  
%  