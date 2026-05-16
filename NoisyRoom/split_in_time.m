function split_in_time(fname, Tinit, Tend)

[inaddr,ints]=loadaerdat(fname); %'../Alex_Spanish_-90degrees.aedat'); %'DAViS240-2014-11-04T15-50-24+0100-0.aedat');

ints = ints - min(ints);
indt = find(ints > Tinit);
inaddr = inaddr(indt);
ints = ints(indt);
indt = find(ints < Tend);
inaddr = inaddr(indt);
ints = ints(indt);

saveaerdat(ints,inaddr,['time\\' fname '_time' int2str(Tend/1000) 'ms.aedat']);