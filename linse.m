
close all
clear all

%% Const
folder='Z:\Projects\1060 FDML\weitfeldlinse\v2\';
data = dlmread(strcat(folder,'x0.0000y0.0000.txt'),'\t');

rec=1;%record data for composit image
getgif=0;%1 if yes

binning=3;
resizefactor=2;
figure;
imagesc(data);set(gca, 'XTick', [],'YTick', []);colormap('hot');
set(gca,'position',[0 0 1 1],'units','normalized');
saveas(gcf,'testing.png');
a1=imread('testing.png');
sV=size(a1);

pixelsize=1.67;%micrometer
sizefactor=binning*resizefactor*pixelsize;
voltageSteps=41;
XYVMax=7.5;
XYVMin=-7.5;
WinkelMin=-43;
WinkelMax=43;
Threshold=20; %Background cut off


%% Size and Voltage

width=data(2);
height=data(1);

widthResize=width/resizefactor;
heightResize=height/resizefactor;

tmp=linspace(XYVMin,XYVMax,41);
for k=1:41
        Volt{k}=sprintf('%0.4f',tmp(k));
end

%% Further Init
% get names in directory
listing=dir(folder);
list=struct2cell(listing);
list=list(1,1:end);

% reserv space
a=zeros(height*voltageSteps/2,width*voltageSteps/2);
ana=struct;
DATA=zeros(heightResize,widthResize);

%for gif
figure(1);
filename = 'ImageStack.gif';
n=0;

%% read and analyse images
for k=0:voltageSteps-1
    k
    for l=0:voltageSteps-1
        n=n+1
        anindex=n;%k*voltageSteps+l+1;%index for struct
        if n==302
            n;
        end
        name=strcat('x',Volt{k+1},'y',Volt{l+1});
        x = strmatch(strcat(name,'.txt'),list);%check if name is in the directory
        
        ana(anindex).flag=0;% init element as non existing
        
        if ~isempty(x)%check if name is in the directory
            
            %data read
            data = dlmread(strcat(folder,name,'.txt'),'\t');
            data(1:2)=[];
            data=reshape(data,[width,height])';
            
            if getgif %record gif
                imagesc(data);
                title(strcat('x',num2str(Volt{k+1}),'y',num2str(Volt{l+1})))
                drawnow
                frame = getframe(1);
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
                if n == 1;
                    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
                else
                    imwrite(imind,cm,filename,'gif','WriteMode','append');
                end
            end
            
            data=imresize(data,1/resizefactor);%resize because of memory
            DATA=DATA+data;%total intensity
            a(k*heightResize+1:(k+1)*heightResize,l*widthResize+1:(l+1)*widthResize)=data;%stiched image
            if max(data(:))>Threshold %determin existance of viable beamprofile
                %analyse data
                [sizeHalfmax,meank,meanl,angle,FWHM,Abweichungform,SizeABPI,IntensityEl,IntensityRe,IntensityTot,lkel,coeff]=analysis(data,name,rec);
                
                BildT(k*sV(1)+1:(k+1)*sV(1),l*sV(2)+1:(l+1)*sV(2),:)=imread(strcat('StrahlvermessungProcessedData/',name,'.png'));
                %store analysis to struct
                ana(anindex).sizeHalfmax=sizeHalfmax;
                ana(anindex).meank=meank;
                ana(anindex).meanl=meanl;
                ana(anindex).angle=angle;
                ana(anindex).FWHM=FWHM;
                ana(anindex).Abweichungform=Abweichungform;
                ana(anindex).SizeABPI=SizeABPI;
                ana(anindex).IntensityEl=IntensityEl;
                ana(anindex).IntensityRe=IntensityRe;
                ana(anindex).IntensityTot=IntensityTot;
                ana(anindex).lkel=lkel;
                ana(anindex).coeff=coeff;
                
                %mark as existing
                ana(anindex).flag=1;
                
            else
                %mark as non existing
                if rec
                    figure;
                    imagesc(data);set(gca, 'XTick', [],'YTick', []);colormap('hot');caxis([0 300]);
                    set(gca,'position',[0 0 1 1],'units','normalized');
                    saveas(gcf,strcat('StrahlvermessungProcessedData/',name,'.png'));
                    close;
                end
                BildT(k*sV(1)+1:(k+1)*sV(1),l*sV(2)+1:(l+1)*sV(2),:)=imread(strcat('StrahlvermessungProcessedData/',name,'.png'));
                ana(anindex).flag=0;
            end
            
        end
    end
end

%% Further analysis
%sizeHalfmax,meank,meanl,angle,FWHM,Abweichungform,SizeABPI,IntensityEl,IntensityRe,lkel,coeff

h=figure;
imagesc(a)

%Init storage space
IntensityEl=NaN(voltageSteps);
IntensityRe=NaN(voltageSteps);
IntensityTot=NaN(voltageSteps);
Theta=NaN(voltageSteps);
FWHM=NaN(voltageSteps,voltageSteps,2);
RatioEccentricity=NaN(voltageSteps);
klMovement=NaN(voltageSteps,voltageSteps,3);
Size=NaN(voltageSteps);
%SizeAbpi=NaN(voltageSteps);
Deformation=NaN(voltageSteps);%abweichungform
MittelP=NaN(voltageSteps,voltageSteps,2);

%determin 0V/0V midpoint
Mittelk=ana(round(length(ana)/2)).meank;
Mittell=ana(round(length(ana)/2)).meanl;

for k=0:voltageSteps-1
    for l=0:voltageSteps-1
        %index and offsets for stiched image
        anindex=k*voltageSteps+l+1;
        loffset=l*widthResize;
        koffset=k*heightResize;
        
        if ana(anindex).flag %check if existing
            %load data
            
            %further analysis
            IntensityEl(k+1,l+1)=ana(anindex).IntensityEl;
            IntensityRe(k+1,l+1)=ana(anindex).IntensityRe;
            IntensityTot(k+1,l+1)=ana(anindex).IntensityTot;
            Theta(k+1,l+1)=ana(anindex).angle;
            
            FWHM(k+1,l+1,1)=ana(anindex).FWHM(1);
            FWHM(k+1,l+1,2)=ana(anindex).FWHM(2);
            if ana(anindex).FWHM(1)<ana(anindex).FWHM(2)
                FWHM(k+1,l+1,1)=ana(anindex).FWHM(2);
                FWHM(k+1,l+1,2)=ana(anindex).FWHM(1);
            end
            klMovement(k+1,l+1,1)=ana(anindex).meank-Mittelk;
            klMovement(k+1,l+1,2)=ana(anindex).meanl-Mittell;
            klMovement(k+1,l+1,3)=(( klMovement(k+1,l+1,1))^2+(klMovement(k+1,l+1,2))^2)^.5;
            
            RatioEccentricity(k+1,l+1)=min(FWHM(k+1,l+1,2),FWHM(k+1,l+1,1))/max(FWHM(k+1,l+1,2),FWHM(k+1,l+1,1));
            Size(k+1,l+1)=ana(anindex).SizeABPI;
            MittelP(k+1,l+1,:)=[ana(anindex).meank;ana(anindex).meanl];
            
            %plot elipse,etc into stiched image
            kpcaM=ana(anindex).coeff(1,1);
            lpcaM=ana(anindex).coeff(2,1);
            kpcaS=ana(anindex).coeff(1,2);
            lpcaS=ana(anindex).coeff(2,2);
            
            kpcaMoff=kpcaM*100+ana(anindex).meank;
            lpcaMoff=lpcaM*100+ana(anindex).meanl;
            kpcaSoff=kpcaS*100+ana(anindex).meank;
            lpcaSoff=lpcaS*100+ana(anindex).meanl;
            hold on;
            plot([meanl+loffset,lpcaMoff+loffset],[meank+koffset,kpcaMoff+koffset]+koffset,'r','LineWidth',1);hold on;
            plot([meanl,lpcaSoff]+loffset,[meank,kpcaSoff]+koffset,'b','LineWidth',1);hold on;
            plot(ana(anindex).meanl+loffset,ana(anindex).meank+koffset,'r.');hold on;
            plot(ana(anindex).lkel(1,:)+ana(anindex).meanl+loffset,ana(anindex).lkel(2,:)+ana(anindex).meank+koffset);
            %plot(xmittelp+loffset,ymittelp+koffset,'ro');hold on ;
            %plot(indexr(:,1)+loffset,indexr(:,2)+koffset,'r');hold on;
            %plot(xyelips(1,:)+loffset,xyelips(2,:)+koffset,'k');
            
        end
    end
end
%savefig(h,'stiched.fig','compact')

%save('data','-v7.3');
