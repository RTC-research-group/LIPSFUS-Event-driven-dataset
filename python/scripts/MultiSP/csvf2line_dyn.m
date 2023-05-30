function l = csvf2line_dyn(fname, imgfname,sdir)

file=transpose(csvread(fname,0,0));
[a,b]=size(file);
sx=24; %32
sy=16; %24
hist = zeros (sx,sy);
for i=1:b %probar a poner un if que compruebe si la x es menor que 24 y la y menor que 16
    if (mod(floor(mod(file(1,i),256)/4),32)<24 && floor(file(1,i)/256/2) < 16)
        hist(mod(floor(file(1,i)/4),32)+1, mod(floor(file(1,i)/256/2),24)+1) = hist(mod(floor(file(1,i)/4),32)+1,mod(floor(file(1,i)/256/2),24)+1) + file(2,i);
    end
end
hist = floor(100*hist/max(max(hist)));
f=figure(1);
image((hist'));
x0=10;
y0=10;
width=640;
height=480
set(gcf,'position',[x0,y0,width,height])
title(['words visual' replace(imgfname(1:length(imgfname)-4),'_',' ')]);
if ~exist('ds', 'dir')
    mkdir('ds')
end
if ~exist('ds\\img_dyn', 'dir')
    mkdir('ds\\img_dyn')
end
if ~exist(['ds\\img_dyn\\' sdir], 'dir')
    mkdir(['ds\\img_dyn\\' sdir])
end
saveas(f,['ds\\img_dyn\\' sdir '\\' replace(imgfname(1:length(imgfname)-4),'_',' ') '.png']);
line_csv = reshape(hist,1,sx*sy); %32 element column after 32 element colum for the 24 columns of the 32x24 histogram of the lips
%hist(1,:)
%line_csv(1:32)
l=line_csv;