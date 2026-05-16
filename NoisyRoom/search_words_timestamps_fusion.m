function search_words_timestamps_fusion(fname, threshold, shift_earlier)
%divede an AEDAT file with NAS output in isolated spoken words according to
%a threshold in the spike rate global activity with 40ms time-bin
[inaddr,ints]=loadaerdat(fname); 
words_name =  ['one    '; 'two    '; 'three  '; 'four   '; 'five   '; 'Six    '; 'Seven  '; 'Eight  '; 'Nine   '; 'Zero   '; ... 
    'Oh     '; 'Yes    '; 'No     '; 'Up     '; 'Down   '; 'Left   '; 'Right  '; 'On     '; 'Off    '; 'Stop   '; 'Go     '; ... 
    'Bed    '; 'Bird   '; 'Cat    '; 'Dog    '; 'Happy  '; 'House  '; 'Marvin '; 'Sheila '; 'Tree   '; 'Wow    '; ... 
    'About  '; 'Border '; 'Forward'; 'Missing'; 'Press  '; 'Short  '; 'Threat '; 'Young  '; ...
    'FoxDog '];

ints = ints - min(ints);

indcoch = find(inaddr >32767);
coch = mod((inaddr(indcoch)),256);
tscoch = ints(indcoch);

indret = find(inaddr <32768);
ret = inaddr(indret);
tsret = ints(indret);

[a,b] = size(coch);

ts=0;
b=1;
avg=zeros(ceil(a),2);
words_ts = zeros (100,2);
words_ts(1,1) = -750000;
i=1;
c=1;
while i<a % Loop to calculate spike-rate activity in 40ms time-bins over the whole recording and to detect the timestamp where this activity goes beyond a threshold, so it can be considered as an spoken word.
    if (tscoch(i)-ts < 40000)
        avg(b,1) = avg(b,1) + 1;
        i = i+1;
    else
        avg(b,2) = tscoch(i);
        if (avg(b,1) > threshold && (tscoch(i) - words_ts(c,1)) > 750000) 
            c = c+1;
            words_ts(c,1) = tscoch(i) - shift_earlier;
            words_ts(c,2) = words_ts(c,1) + 750000; %0,75seconds for a word
        end
        b = b +1;
        i=b;
        ts = tscoch(i);
    end
end
words_ts_found = words_ts(1:c,:);
f=figure(1);
plot(avg(:,2),avg(:,1),'r.');
hold on
for j=2:c %Draw lines for those detected timestamps to be used to split the words
    line((words_ts(j,1))*ones(14000,1),[1:1:14000],'Color','Blue')
    line((words_ts(j,2))*ones(14000,1),[1:1:14000],'Color','Black')
end 
hold off
title(['words audio' replace(fname(1:length(fname)-6),'_',' ')]);

if ~exist('words_fusion', 'dir')
    mkdir('words_fusion')
end
if ~exist('CSVwords_fusion', 'dir')
    mkdir('CSVwords_fusion')
end
if ~exist('words_audio', 'dir')
    mkdir('words_audio')
end
if ~exist('CSVwords_audio', 'dir')
    mkdir('CSVwords_audio')
end
if ~exist('words_visual', 'dir')
    mkdir('words_visual')
end
if ~exist('CSVwords_visual', 'dir')
    mkdir('CSVwords_visual')
end
    
saveas(f,['words_fusion\\' fname(1:length(fname)-6) '.png']);
saveas(f,['CSVwords_fusion\\' fname(1:length(fname)-6) '.png']);
saveas(f,['words_audio\\' fname(1:length(fname)-6) '.png']);
saveas(f,['words_visual\\' fname(1:length(fname)-6) '.png']);
saveas(f,['CSVwords_audio\\' fname(1:length(fname)-6) '.png']);
saveas(f,['CSVwords_visual\\' fname(1:length(fname)-6) '.png']);

w = 1;
for h=2:c % Loop to split the long AEDAT files into smaller ones contaning one word. It also save this in CSV format for later SNN training
    Tinit = words_ts_found(h,1); 
    Tend = words_ts_found(h,2); 

    if (h>2 && (words_ts_found(h,1) - words_ts_found(h-1,2)) > 500000)
        w = w + ceil((words_ts_found(h,1) - words_ts_found(h-1,2))/1e6);
    end
    
    if (w <40)
        indt = find(ints > Tinit); % This block is to store combined audio and visual AE information
        inaddr1 = inaddr(indt);
        ints1 = ints(indt);
        indt = find(ints1 < Tend);
        inaddr2 = inaddr1(indt);
        ints2 = ints1(indt);
        ints2 = ints2 - min(ints2);
        saveaerdat(ints2,inaddr2,['words_fusion\\' fname(1:length(fname)-6) '_word_fusion_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '.aedat']);
        %saving CSV file of each detected word
        a=[ints2,inaddr2];
        csvwrite(['CSVwords_fusion\\' fname(1:length(fname)-6) '_word_fusion_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_ts.csv'],a,0,0);
        %saving CSV file of histogram of each detected word
        %[GC,GR] = groupcounts(inaddr2); % Matlab 2019/2020
        %x=[GC,GR];
        b=unique(inaddr2); %Matlab 2018
        x=[b,histc(inaddr2(:),b)];
        csvwrite(['CSVwords_fusion\\' fname(1:length(fname)-6) '_word_fusion_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_hist.csv'],x,0,0);
        
        indt = find(tscoch > Tinit); % This block is to store only audio AE information
        coch1 = coch(indt);
        tscoch1 = tscoch(indt);
        indt = find(tscoch1 < Tend);
        coch2 = coch1(indt);
        tscoch2 = tscoch1(indt);
        tscoch2 = tscoch2 - min(tscoch2);
        saveaerdat(tscoch2,coch2,['words_audio\\' fname(1:length(fname)-6) '_word_audio_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '.aedat']);
        %saving CSV file of each detected word
        a=[tscoch2,coch2];
        csvwrite(['CSVwords_audio\\' fname(1:length(fname)-6) '_word_audio_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_ts.csv'],a,0,0);
        %saving CSV file of histogram of each detected word
        %[GC,GR] = groupcounts(coch2);
        %x=[GC,GR];
        b=unique(coch2);
        x=[b,histc(coch2(:),b)];
        csvwrite(['CSVwords_audio\\' fname(1:length(fname)-6) '_word_audio_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_hist.csv'],x,0,0);
        
        
        indt = find(tsret > Tinit); % This block is to store only visual AE information
        ret1 = ret(indt);
        tsret1 = tsret(indt);
        indt = find(tsret1 < Tend);
        ret2 = ret1(indt);
        tsret2 = tsret1(indt);
        tsret2 = tsret2 - min(tsret2);
        saveaerdat(tsret2,ret2,['words_visual\\' fname(1:length(fname)-6) '_word_visual_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '.aedat']);
        %saving CSV file of each detected word
        a=[tsret2,ret2];
        csvwrite(['CSVwords_visual\\' fname(1:length(fname)-6) '_word_visual_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_ts.csv'],a,0,0);
        %saving CSV file of histogram of each detected word
        %[GC,GR] = groupcounts(ret2);
        %x=[GC,GR];
        b=unique(ret2);
        x=[b,histc(ret2(:),b)];
        csvwrite(['CSVwords_visual\\' fname(1:length(fname)-6) '_word_visual_' strtrim(words_name(w,:)) '_th_' num2str(threshold) '_prets_' num2str(shift_earlier) '_ts_' num2str(Tinit) '_' num2str(Tend) '_hist.csv'],x,0,0);
        
        h
        w=w+1
    end
end