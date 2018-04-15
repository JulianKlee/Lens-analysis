function [ Vq ] = CutoffInterpol( X,Xq,Y,Yq,V,cutlevel,invert)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
st=std(V(:),'omitnan');
meanV=mean(V(:),'omitnan');
if invert
    V(abs(V)<abs(meanV)+st*cutlevel)=meanV;
else
    V(abs(V)>abs(meanV)+st*cutlevel)=meanV;
end
%Theta(1:3,:)=meanTheta;Theta(end-2:end,:)=meanTheta;Theta(:,1:3)=meanTheta;Theta(:,end-2:end)=meanTheta;
%Theta=inpaint_nans(Theta,5);
valid     = ~isnan(V) ;
VI = griddata(X(valid),Y(valid),V(valid), X, Y ) ;
Vq = interp2(X,Y,VI,Xq,Yq,'linear');

end

