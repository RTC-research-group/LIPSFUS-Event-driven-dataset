listing = dir('.');

[a,b] = size(listing)
for i=1:a
    if listing(i).isdir == 0
        if strcmp(listing(i).name(end-5:end),'.aedat')
             listing(i).name
             search_words_timestamps_fusion(listing(i).name,4600,100000);
             i
        end
    end
end

