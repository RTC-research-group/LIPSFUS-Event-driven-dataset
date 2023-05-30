function x=getx_snn(net)

%
x=[];
for iLayer=1:net.numLayers-1
    x=[x;cell2mat(net.w{iLayer,iLayer+1}(:))];
end