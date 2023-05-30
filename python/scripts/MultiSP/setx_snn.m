function net=setx_snn(net,xname,x)


s=net.size;
sp=1;
for iLayer=2:net.numLayers;
    nr=s(iLayer-1)*s(iLayer);
    temp=x(sp:sp+nr-1,:);
    temp=mat2cell(temp,ones(1,nr),net.numSynapses);
    xname_val{iLayer-1,iLayer}=reshape(temp,s(iLayer-1),s(iLayer));
    sp=sp+nr;
end
expression=['setfield(net,' xname ',xname_val);'];
net = eval(expression);