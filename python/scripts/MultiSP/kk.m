file=transpose(csvread('alejandro2 bci -90deg_lips_73_78_word_visual_one_th_5000_prets_100000_ts_11072312_12572312_hist.csv',0,0));
[a,b]=size(file);
hist = zeros (32,24);
for i=1:b
    hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) = hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) + file(2,i);
end
hist = 100*hist/max(max(hist));
figure;
image(hist);
line_csv = reshape(hist,1,32*24); %32 element column after 32 element colum for the 24 columns of the 32x24 histogram of the lips
hist(1,:)
line_csv(1:32)