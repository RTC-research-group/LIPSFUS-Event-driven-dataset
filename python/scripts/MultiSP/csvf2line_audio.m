function l = csvf2line_audio(fname, imgfname,sdir)

file=transpose(csvread(fname,0,0));
[a,b]=size(file);
hist = zeros (128,1);
hist = file(2,1:2:end) + file(2,2:2:end)
hist = hist(1:end/2) + hist(end/2+1:end);
% for i=1:b
%     hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) = hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) + file(2,i);
% end
hist = floor(100*hist/max(max(hist)));
f=figure(1);
plot(hist');
x0=10;
y0=10;
width=640;
height=480
set(gcf,'position',[x0,y0,width,height])
title(['words audio' replace(imgfname(1:length(imgfname)-4),'_',' ')]);
if ~exist('ds', 'dir')
    mkdir('ds')
end
if ~exist('ds\\aud', 'dir')
    mkdir('ds\\aud')
end
if ~exist(['ds\\aud\\' sdir], 'dir')
    mkdir(['ds\\aud\\' sdir])
end
saveas(f,['ds\\aud\\' sdir '\\' replace(imgfname(1:length(imgfname)-4),'_',' ') '.png']);
line_csv = hist; 
l=line_csv';