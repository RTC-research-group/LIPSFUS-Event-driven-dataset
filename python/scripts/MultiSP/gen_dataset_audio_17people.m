listing = dir('.\ds\CSVwords_audio_17people\');
dataset1 = zeros (64,100);
dataset2 = zeros (64,100);
dataset3 = zeros (64,100);
dataset4 = zeros (64,100);
dataset5 = zeros (64,100);
dataset6 = zeros (64,100);
dataset7 = zeros (64,100);
dataset8 = zeros (64,100);
dataset9 = zeros (64,100);
datasetz = zeros (64,100);
dataseto = zeros (64,100);

[a,b] = size(listing);
i1=1; i2=1; i3=1; i4=1; i5=1; i6=1; i7=1; i8=1; i9=1; iz=1; io=1;

for i=1:a
    if listing(i).isdir == 0
        if strcmp(listing(i).name(end-8:end),'_hist.csv')
             listing(i).name
             fname = ['.\ds\CSVwords_audio_17people\' listing(i).name];
             if (strfind(listing(i).name,'one'))
                 dataset1(:,i1)=csvf2line_audio(fname, listing(i).name, 'one'); i1=i1+1;
             end
             if (strfind(listing(i).name,'two'))
                 dataset2(:,i2)=csvf2line_audio(fname, listing(i).name,'two'); i2=i2+1;
             end
             if (strfind(listing(i).name,'three'))
                 dataset3(:,i3)=csvf2line_audio(fname, listing(i).name,'three'); i3=i3+1;
             end
             if (strfind(listing(i).name,'four'))
                 dataset4(:,i4)=csvf2line_audio(fname, listing(i).name,'four'); i4=i4+1;
             end
             if (strfind(listing(i).name,'five'))
                 dataset5(:,i5)=csvf2line_audio(fname, listing(i).name,'five'); i5=i5+1;
             end
             if (strfind(listing(i).name,'Six'))
                 dataset6(:,i6)=csvf2line_audio(fname, listing(i).name,'Six'); i6=i6+1;
             end
             if (strfind(listing(i).name,'Seven'))
                 dataset7(:,i7)=csvf2line_audio(fname, listing(i).name,'Seven'); i7=i7+1;
             end
             if (strfind(listing(i).name,'Eight'))
                 dataset8(:,i8)=csvf2line_audio(fname, listing(i).name,'Eight'); i8=i8+1;
             end
             if (strfind(listing(i).name,'Nine'))
                 dataset9(:,i9)=csvf2line_audio(fname, listing(i).name,'Nine'); i9=i9+1;
             end
             if (strfind(listing(i).name,'Zero'))
                 datasetz(:,iz)=csvf2line_audio(fname, listing(i).name,'Zero'); iz=iz+1;
             end
             if (strfind(listing(i).name,'Oh'))
                 dataseto(:,io)=csvf2line_audio(fname, listing(i).name,'Oh'); io=io+1;
             end
             i
        end
    end
end

datasetin_tr = [dataset1(:,1:i1-41) dataset2(:,1:i2-41) dataset3(:,1:i3-41) dataset4(:,1:i4-41) dataset5(:,1:i5-41)];
datasetin_tr = [datasetin_tr dataset6(:,1:i6-41) dataset7(:,1:i7-41) dataset8(:,1:i8-41) dataset9(:,1:i9-41)];
datasetin_tr = [datasetin_tr datasetz(:,1:iz-41) dataseto(:,1:io-41)];

datasetout_tr = [[dataset1(:,1:i1-41); 200+10*ones(1,i1-41)] [dataset2(:,1:i2-41); 200+10*2*ones(1,i2-41)] [dataset3(:,1:i3-41); 200+10*3*ones(1,i3-41)]];
datasetout_tr = [datasetout_tr [dataset4(:,1:i4-41); 200+10*4*ones(1,i4-41)] [dataset5(:,1:i5-41); 200+10*5*ones(1,i5-41)]];
datasetout_tr = [datasetout_tr [dataset6(:,1:i6-41); 200+10*6*ones(1,i6-41)] [dataset7(:,1:i7-41); 200+10*7*ones(1,i7-41)]];
datasetout_tr = [datasetout_tr [dataset8(:,1:i8-41); 200+10*8*ones(1,i8-41)] [dataset9(:,1:i9-41); 200+10*9*ones(1,i9-41)]];
datasetout_tr = [datasetout_tr [datasetz(:,1:iz-41); 200+10*10*ones(1,iz-41)] [dataseto(:,1:io-41); 200+10*11*ones(1,io-41)]];

datasetin_va = [dataset1(:,i1-40:i1-1) dataset2(:,i2-40:i2-1) dataset3(:,i3-40:i3-1) dataset4(:,i4-40:i4-1) dataset5(:,i5-40:i5-1)];
datasetin_va = [datasetin_va dataset6(:,i6-40:i6-1) dataset7(:,i7-40:i7-1) dataset8(:,i8-40:i8-1) dataset9(:,i9-40:i9-1)];
datasetin_va = [datasetin_va datasetz(:,iz-40:iz-1) dataseto(:,io-40:io-1)];

datasetout_va = [[dataset1(:,i1-40:i1-1); 200+10*ones(1,40)] [dataset2(:,i2-40:i2-1); 200+10*2*ones(1,40)] [dataset3(:,i3-40:i3-1); 200+10*3*ones(1,40)]];
datasetout_va = [datasetout_va [dataset4(:,i4-40:i4-1); 200+10*4*ones(1,40)] [dataset5(:,i5-40:i5-1); 200+10*5*ones(1,40)]];
datasetout_va = [datasetout_va [dataset6(:,i6-40:i6-1); 200+10*6*ones(1,40)] [dataset7(:,i7-40:i7-1); 200+10*7*ones(1,40)]];
datasetout_va = [datasetout_va [dataset8(:,i8-40:i8-1); 200+10*8*ones(1,40)] [dataset9(:,i9-40:i9-1); 200+10*9*ones(1,40)]];
datasetout_va = [datasetout_va [datasetz(:,iz-40:iz-1); 200+10*10*ones(1,40)] [dataseto(:,io-40:io-1); 200+10*11*ones(1,40)]];

csvwrite('.\\ds\\dataset_audio_lips_64ch_in_train.csv',datasetin_tr',0,0);
csvwrite('.\\ds\\dataset_audio_lips_64ch_out_train.csv',datasetout_tr',0,0);
csvwrite('.\\ds\\dataset_audio_lips_64ch_in_val.csv',datasetin_va',0,0);
csvwrite('.\\ds\\dataset_audio_lips_64ch_out_val.csv',datasetout_va',0,0);