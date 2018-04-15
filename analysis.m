function [ sizeHalfmax,meank,meanl,angle,FWHM,Abweichungform,SizeABPI,IntensityEl,IntensityRe,IntensityTot,lkel,coeff] = analysis(data,name,rec)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%load('temp');
%Filter data and make binary with threshold
filtBild=medfilt2(data);
IntensityTot=mean(data(:));
BinBild=zeros(size(data));
BinBild(data>=max(filtBild(:))*0.5)=1;
%bin image to k l vectors
[k,l]=find(BinBild);
%spotsize spotes at 50%cutoff
sizeHalfmax=length(k);

%centerpoints
meank=mean(k);
meanl=mean(l);
%translate to 0/0
k00=k-meank;
l00=l-meanl;

% figure
% plot(l00,k00,'*');% index matrix of image to plot k=y l=x;
% axis('equal');
%principal componant analysis
A=([k00,l00]);
[coeff,score,latend] = pca(A); %coef gives Vectors relative to 00 for pinc Compts; 
%score is the projection of all points on these vectors

%index matrix of image to plot k=y l=x;

% figure; plot(score(:,1),ones(size(score,1),1),'r*');hold on;plot(score(:,2),ones(size(score,1),1),'b*')

% figure;plot(A(:,2),A(:,1),'b*');axis('equal');hold on;
% 

%extract coeffs for Main and second pinc Comp
kpcaM=coeff(1,1);
lpcaM=coeff(2,1);
kpcaS=coeff(1,2);
lpcaS=coeff(2,2);


% figure;
% plot([0,lpcaM]*10,[0,kpcaM]*10, 'r', 'LineWidth', 4);hold on;plot([0,lpcaS]*10,[0,kpcaS]*10, 'b', 'LineWidth', 4);axis('equal');

%extend verctor and move to intensitycenter and plot

kpcaMoff=kpcaM*100+mean(k);lpcaMoff=lpcaM*100+mean(l);kpcaSoff=kpcaS*100+mean(k);lpcaSoff=lpcaS*100+mean(l);



%get the angle to the horizontal keep in mind k=y and l=x!!!
normal=[0 1];
anglevec=[kpcaM, lpcaM];
angledot=dot(normal, anglevec);
angle=(acos(angledot));

%get FWHM
FWHM=range(score,1);
%get Size of elipse
SizeABPI=FWHM(1)/2*FWHM(2)/2*pi;

% create elipse 
t=-pi:0.01:pi;
ra=FWHM(1)/2;
rb=FWHM(2)/2;
xel=ra*cos(t);
yel=rb*sin(t);

%figure;plot(xel,yel);
%rotate elipse to match calculated angle
rot=[cos(angle),-sin(angle);sin(angle),cos(angle)];
lkel=rot*[xel;yel];

%binary image of elipse
BinBildEl=zeros(size(BinBild));
xtemp=round(lkel(2,:)+meank);ytemp=round(lkel(1,:)+meanl);

for xt=1:length(xtemp)
    if xtemp(xt)>0 && xtemp(xt)<=size(BinBild,1) && ytemp(xt)>0 && ytemp(xt)<=size(BinBild,2)
        BinBildEl(xtemp(xt),ytemp(xt))=1;
    end
end
%fill elipse
BinBildEl=BinBildEl+regiongrowing(BinBildEl,round(meank),round(meanl),0.5);
%get difference
DiffBinBild=abs(BinBild-BinBildEl);
%normalized error
Abweichungform=sum(DiffBinBild(:))/sum(BinBildEl(:));

% figure;imagesc(BinBildEl);hold on; plot(lkel(1,:)+meanl,lkel(2,:)+meank);
% figure;imagesc(BinBildEl);hold on;plot(ytemp,xtemp);
% figure;imagesc(DiffBinBild);
% figure;imagesc(data);hold on;
if rec
    figure;imagesc(data);colormap('hot');hold on;caxis([0 300]);
    plot([meanl,lpcaMoff],[meank,kpcaMoff],'g','LineWidth',1);hold on;
    plot([meanl,lpcaSoff],[meank,kpcaSoff],'b','LineWidth',1);hold on;
    plot(meanl,meank,'r.');hold on;
    plot(lkel(1,:)+meanl,lkel(2,:)+meank);
    set(gca, 'XTick', [],'YTick', []);
    set(gca,'position',[0 0 1 1],'units','normalized')
    saveas(gcf,strcat('StrahlvermessungProcessedData/',name,'.png'));
    close;
end
% Intensity of FWHM region or elipse
IntensityEl=mean(BinBildEl(:).*data(:));
IntensityRe=mean(BinBild(:).*data(:));


end

