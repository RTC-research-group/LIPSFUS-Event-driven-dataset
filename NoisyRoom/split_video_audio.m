function split_video_audio(fname)

[inaddr,ints]=loadaerdat(fname); %'../Alex_Spanish_-90degrees.aedat'); %'DAViS240-2014-11-04T15-50-24+0100-0.aedat');

Tinit = 0; 
Tend = 1e11; 

ints = ints - min(ints);
indt = find(ints > Tinit);
inaddr = inaddr(indt);
ints = ints(indt);
indt = find(ints < Tend);
inaddr = inaddr(indt);
ints = ints(indt);

indcoch = find(inaddr >32767);
coch = mod((inaddr(indcoch)),256)+128;
tscoch = ints(indcoch);
[a,b] = size(coch);
ycoch = zeros(a,1);

indret = find(inaddr <32768);
ret = inaddr(indret);
tsret = ints(indret);

sign = bitand(ret,1);
inx = bitand(ret,hex2dec('fe'))/2;
iny = bitand(ret,hex2dec('7f00'))/256;

figure(1);
hold on;
plot3(tsret,inx,iny,'r.');
plot3(tscoch,coch,ycoch,'b.');
hold off;

saveaerdat(tsret,ret,['visual\\' fname '_retina.aedat']);
saveaerdat(tscoch,coch,['audio\\' fname '_cochlea.aedat']);