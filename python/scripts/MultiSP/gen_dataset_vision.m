listing = dir('..\..\lips_extracting\lips\500ms_prets\CSVwords_visual');
dataset1 = zeros (32*24,100);
dataset2 = zeros (32*24,100);
dataset3 = zeros (32*24,100);
dataset4 = zeros (32*24,100);
dataset5 = zeros (32*24,100);
dataset6 = zeros (32*24,100);
dataset7 = zeros (32*24,100);
dataset8 = zeros (32*24,100);
dataset9 = zeros (32*24,100);
datasetz = zeros (32*24,100);
dataseto = zeros (32*24,100);

[a,b] = size(listing);
i1=1; i2=1; i3=1; i4=1; i5=1; i6=1; i7=1; i8=1; i9=1; iz=1; io=1;

for i=1:a
    if listing(i).isdir == 0
        if strcmp(listing(i).name(end-8:end),'_hist.csv')
             listing(i).name
             fname = ['..\..\lips_extracting\lips\500ms_prets\CSVwords_visual\' listing(i).name];
             if (strfind(listing(i).name,'one'))
                 dataset1(:,i1)=csvf2line(fname, listing(i).name, 'one'); i1=i1+1;
             end
             if (strfind(listing(i).name,'two'))
                 dataset2(:,i2)=csvf2line(fname, listing(i).name,'two'); i2=i2+1;
             end
             if (strfind(listing(i).name,'three'))
                 dataset3(:,i3)=csvf2line(fname, listing(i).name,'three'); i3=i3+1;
             end
             if (strfind(listing(i).name,'four'))
                 dataset4(:,i4)=csvf2line(fname, listing(i).name,'four'); i4=i4+1;
             end
             if (strfind(listing(i).name,'five'))
                 dataset5(:,i5)=csvf2line(fname, listing(i).name,'five'); i5=i5+1;
             end
             if (strfind(listing(i).name,'Six'))
                 dataset6(:,i6)=csvf2line(fname, listing(i).name,'Six'); i6=i6+1;
             end
             if (strfind(listing(i).name,'Seven'))
                 dataset7(:,i7)=csvf2line(fname, listing(i).name,'Seven'); i7=i7+1;
             end
             if (strfind(listing(i).name,'Eitght'))
                 dataset8(:,i8)=csvf2line(fname, listing(i).name,'Eight'); i8=i8+1;
             end
             if (strfind(listing(i).name,'Nine'))
                 dataset9(:,i9)=csvf2line(fname, listing(i).name,'Nine'); i9=i9+1;
             end
             if (strfind(listing(i).name,'Zero'))
                 datasetz(:,iz)=csvf2line(fname, listing(i).name,'Zero'); iz=iz+1;
             end
             if (strfind(listing(i).name,'Oh'))
                 dataseto(:,io)=csvf2line(fname, listing(i).name,'Oh'); io=io+1;
             end
             i
        end
    end
end

datasetin = [dataset1(:,1:i1-1) dataset2(:,1:i2-1) dataset3(:,1:i3-1) dataset4(:,1:i4-1) dataset5(:,1:i5-1)];
datasetin = [datasetin dataset6(:,1:i6-1) dataset7(:,1:i7-1) dataset8(:,1:i8-1) dataset9(:,1:i9-1)];
datasetin = [datasetin datasetz(:,1:iz-1) dataseto(:,1:io-1)];

datasetout = [[dataset1(:,1:i1-1); 200+10*ones(1,i1-1)] [dataset2(:,1:i2-1); 200+10*2*ones(1,i2-1)] [dataset3(:,1:i3-1); 200+10*3*ones(1,i3-1)]];
datasetout = [datasetout [dataset4(:,1:i4-1); 200+10*4*ones(1,i4-1)] [dataset5(:,1:i5-1); 200+10*5*ones(1,i5-1)]];
datasetout = [datasetout [dataset6(:,1:i6-1); 200+10*6*ones(1,i6-1)] [dataset7(:,1:i7-1); 200+10*7*ones(1,i7-1)]];
datasetout = [datasetout [dataset8(:,1:i8-1); 200+10*8*ones(1,i8-1)] [dataset9(:,1:i9-1); 200+10*9*ones(1,i9-1)]];
datasetout = [datasetout [datasetz(:,1:iz-1); 200+10*10*ones(1,iz-1)] [dataseto(:,1:io-1); 200+10*11*ones(1,io-1)]];

csvwrite('.\\ds\\dataset_visual_lips_64x48_in_600_train.csv',datasetin(:,1:600)',0,0);
csvwrite('.\\ds\\dataset_visual_lips_64x48_out_600_train.csv',datasetout(:,1:600)',0,0);
csvwrite('.\\ds\\dataset_visual_lips_64x48_in_51_val.csv',datasetin(:,601:end)',0,0);
csvwrite('.\\ds\\dataset_visual_lips_64x48_out_51_val.csv',datasetout(:,601:end)',0,0);