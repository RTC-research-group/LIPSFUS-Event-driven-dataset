function m=cell2mat_snn(c)

m=[];
numLayers=size(c,2);
for iLayer=1:numLayers-1
    temp=c{iLayer,iLayer+1};
    m=[m;cell2mat(temp(:))];
end