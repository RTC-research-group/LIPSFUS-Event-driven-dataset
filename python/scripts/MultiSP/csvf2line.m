function l = csvf2line(fname, imgfname,sdir)

file=transpose(csvread(fname,0,0));
[a,b]=size(file);
hist = zeros (32,24);
for i=1:b
    hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) = hist(mod(floor(file(1,i)/4),32)+1,floor(mod(file(1,i)/256/2,24)+1)) + file(2,i);
end
hist = floor(100*hist/max(max(hist)));
f=figure(1);
image(hist');
x0=10;
y0=10;
width=640;
height=480
set(gcf,'position',[x0,y0,width,height])
title(['words visual' replace(imgfname(1:length(imgfname)-4),'_',' ')]);
if ~exist('ds', 'dir')
    mkdir('ds')
end
if ~exist('ds\\img', 'dir')
    mkdir('ds\\img')
end
if ~exist(['ds\\img\\' sdir], 'dir')
    mkdir(['ds\\img\\' sdir])
end
saveas(f,['ds\\img\\' sdir '\\' replace(imgfname(1:length(imgfname)-4),'_',' ') '.png']);
line_csv = reshape(hist,1,32*24); %32 element column after 32 element colum for the 24 columns of the 32x24 histogram of the lips
%hist(1,:)
%line_csv(1:32)
l=line_csv;