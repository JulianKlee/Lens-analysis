%% Plots
close all
reload=0;
if reload
    clear all
    load('StrahlvermessungProcessedData/data');
end
density=5;
X=ones(voltageSteps,1)*linspace(WinkelMin,WinkelMax,voltageSteps);
Y=X';
Xq=ones(voltageSteps*density,1)*linspace(WinkelMin,WinkelMax,voltageSteps*density);
Yq=Xq';

figure
surf(X,Y,IntensityEl,'EdgeColor','none');
title('mean Intensity of FWHM region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
zlim([0 1.5])
caxis([0 1.5])
colormap('hot');
%%
figure
surf(Xq,Yq,interp2(X,Y,IntensityEl,Xq,Yq,'cubic'),'EdgeColor','none');
title('Mittlere Intensität der FWHM-Region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
daspect([1 1 0.025]);
zlim([0 1.5])
caxis([0 1.5])
colormap('hot');
maxI=max(IntensityEl(:));
emaxI=maxI*1/exp(1);
halfmaxI=maxI*.5;
seventymaxI=maxI*.7;
hold on
s=surf(Xq,Yq,ones(size(Xq))*halfmaxI,'EdgeColor','none');
alpha(s,.8);
colormap('hot');
hold on
s=surf(Xq,Yq,ones(size(Xq))*seventymaxI,'EdgeColor','none');
alpha(s,.6);
zlim([0 1.5])
caxis([0 1.5])
colormap('hot');

temp=interp2(X,Y,IntensityEl,Xq,Yq,'cubic');
temp(temp>halfmaxI)=NaN;
figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('Mittlere Intensität der FWHM-Region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
zlim([0 1.5])
caxis([0 1.5])
daspect([1 1 0.025]);
colormap('hot');

temp=interp2(X,Y,IntensityEl,Xq,Yq,'cubic');
temp(temp>seventymaxI)=NaN;
figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('Mittlere Intensität des 70% Abfalls')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
zlim([0 1.5])
caxis([0 1.5])
daspect([1 1 0.025]);
colormap('hot');

%%
figure
surf(X,Y,IntensityRe,'EdgeColor','none');
title('mean Intensity of FWHM region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
%zlim([0 100])
%caxis([20 100])
colormap('hot');

figure
surf(Xq,Yq,interp2(X,Y,IntensityRe,Xq,Yq,'cubic'),'EdgeColor','none');
title('mean Intensity of FWHM region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
% zlim([0 100])
% caxis([20 100])
colormap('hot');
maxI=max(IntensityRe(:));
emaxI=maxI*1/exp(1);
halfmaxI=maxI*.5;
seventymaxI=maxI*.7;
hold on
s=surf(Xq,Yq,ones(size(Xq))*halfmaxI,'EdgeColor','none');
alpha(s,.8);
colormap('hot');
hold on
s=surf(Xq,Yq,ones(size(Xq))*seventymaxI,'EdgeColor','none');
alpha(s,.6);
% caxis([20 100])
colormap('hot');
xticks([-40 0 40]);
yticks([-40 0 40]);

%%
temp=interp2(X,Y,IntensityRe,Xq,Yq,'cubic');
temp(temp>halfmaxI)=NaN;
figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('mean Intensity of FWHM region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
% zlim([0 100])
% caxis([20 100])
ylim([-40 40]);
colormap('hot');
xticks([-40 0 40]);
yticks([-40 0 40]);

temp=interp2(X,Y,IntensityRe,Xq,Yq,'cubic');
temp(temp>seventymaxI)=NaN;
figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('mean Intensity of FWHM region')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / arb')
saveas(gcf,'mean Intensity of FWHM region.fig')
ylim([-40 40]);
% zlim([0 100])
% caxis([20 100])
colormap('hot');
xticks([-40 0 40]);
yticks([-40 0 40]);

%%

temp1=abs(1-(FWHM(:,:,1)./FWHM(:,:,2)));
temp2=Theta.*temp1;
%temp2(temp1<0.1)=NaN;
figure
surf(Xq,Yq,interp2(X,Y,temp2,Xq,Yq,'linear'),'EdgeColor','none');
colormap('hot');
title('Theta in rad, normiert durch HA zu NA Verhältnis')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / rad')
saveas(gcf,'Theta.fig')
%%
invert=1;
cutlevel=1;
Thetaq=CutoffInterpol(X,Xq,Y,Yq,Theta,cutlevel,invert);
figure
surf(Xq,Yq,Thetaq,'EdgeColor','none');
colormap('hot');
title('Theta in rad')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / rad')
saveas(gcf,'Theta.fig')

invert=0;
Thetaq=CutoffInterpol(X,Xq,Y,Yq,Theta,cutlevel,invert);
figure
surf(Xq,Yq,Thetaq,'EdgeColor','none');
colormap('hot');
title('Theta in rad')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / rad')
saveas(gcf,'Theta.fig')



%%
invert=0;
figure
surf(X,Y,FWHM(:,:,1)*sizefactor);
title('FWHM Hauptachse')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'FWHM HA.fig')

cutlevel=1.5;
temp=CutoffInterpol(X,Xq,Y,Yq,FWHM(:,:,1)*sizefactor,cutlevel,invert);

figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('FWHM Hauptachse')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'FWHM HA.fig')
%%
figure
surf(X,Y,FWHM(:,:,2)*sizefactor);
title('FWHM nebenachse')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'FWHM NA.fig')

cutlevel=1.5;
temp=CutoffInterpol(X,Xq,Y,Yq,FWHM(:,:,2)*sizefactor,cutlevel,invert);

figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('FWHM nebenachse')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'FWHM NA.fig')

%%
temp=FWHM(:,:,2)./FWHM(:,:,1);
temp(temp<.7)=nan;
figure
surf(X,Y,temp);
title('Exzentrizität')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / ratio')
saveas(gcf,'FWHM NAHA.fig')

cutlevel=4;
temp=CutoffInterpol(X,Xq,Y,Yq,temp,cutlevel,invert);

figure
surf(Xq,Yq,1-temp,'EdgeColor','none');
title('Invertierte Exzentrizität')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / ratio')
saveas(gcf,'FWHM NAHA.fig')
colormap('hot')
xlim([-45 45])
ylim([-45 45])
zlim([0 .5])
%caxis([0 .5])
daspect([1 1 0.025]);
xticks([-40 0 40]);
yticks([-40 0 40]);

%%
density=5;
X=ones(voltageSteps,1)*linspace(WinkelMin,WinkelMax,voltageSteps);
Y=X';
Xq=ones(voltageSteps*density,1)*linspace(WinkelMin,WinkelMax,voltageSteps*density);
Yq=Xq';

figure
surf(X,Y,klMovement(:,:,1)*sizefactor);
title('xyMovement x')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementx.fig')

figure
surf(Xq,Yq,interp2(X,Y,klMovement(:,:,1)*sizefactor,Xq,Yq,'cubic'),'EdgeColor','none');
title('Bewegung des Strahlzentrums entlang X')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementx.fig')
colormap('hot')
caxis([-2500 2500])
xticks([-40 0 40]);
yticks([-40 0 40]);
zticks([-2000 0 2000]);
zlim([-2500 2500])
%%
figure
surf(X,Y,klMovement(:,:,2)*sizefactor);
title('xyMovement y')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementy.fig')

figure
surf(Xq,Yq,interp2(X,Y,klMovement(:,:,2)*sizefactor,Xq,Yq,'cubic'),'EdgeColor','none');
title('Bewegung des Strahlzentrums entlang Y')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementx.fig')
colormap('hot')
caxis([-2500 2500])
xticks([-40 0 40]);
yticks([-40 0 40]);
zticks([-2000 0 2000]);
zlim([-2500 2500])
%%

figure
surf(X,Y,klMovement(:,:,3)*sizefactor);
title('xyMovement dist')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementDist.fig')

figure
surf(Xq,Yq,interp2(X,Y,klMovement(:,:,3)*sizefactor,Xq,Yq,'cubic'),'EdgeColor','none');
title('Bewegungsdistanz zum 0°/0° Zustand')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer')
saveas(gcf,'xyMovementx.fig')
colormap('hot')
caxis([0 2500])
xticks([-40 0 40]);
yticks([-40 0 40]);
zticks([0 2000]);
zlim([0 2500])
%%

figure
surf(X,Y,RatioEccentricity);
title('RatioEccentricity')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / e')
saveas(gcf,'eccentricity.fig')

cutlevel=1.5;
temp=CutoffInterpol(X,Xq,Y,Yq,RatioEccentricity,cutlevel,invert);

figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('RatioEccentricity')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / e')
saveas(gcf,'eccentricity.fig')
colormap('hot')
caxis([0 1])
%%
figure
temp=Size*sizefactor*binning*resizefactor;
temp(temp>2*mean(temp(~isnan(temp))))=nan;
temp(temp<0.7*mean(temp(~isnan(temp))))=nan;
surf(X,Y,temp);
title('Size')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer^2')
saveas(gcf,'Size.fig')

cutlevel=1.5;
temp=CutoffInterpol(X,Xq,Y,Yq,temp,cutlevel,invert);

figure
surf(Xq,Yq,temp,'EdgeColor','none');
title('Size')
xlabel('X-Galavnometerauslenkung / °')
ylabel('Y-Galavnometerauslenkung / °')
zlabel('z / micrometer^2')
saveas(gcf,'Size.fig')

colormap('hot')
xticks([-40 0 40]);
yticks([-40 0 40]);
%%
figure
plot((MittelP(2,:)-Mittell)*sizefactor,(MittelP(1,:)-Mittelk)*sizefactor,'r*');
axis('equal')
xlabel('x / micrometer')
ylabel('y / micrometer')
title('Mittelpunkte')
saveas(gcf,'Size.fig')
%%
figure 
imagesc(DATA)
colormap('hot')
title('Gemitteltes Bild')
saveas(gcf,'TotalImage.fig')