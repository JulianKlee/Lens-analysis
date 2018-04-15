close all
clear all
tic
folder='C:/Users/kleej/Documents/MATLAB/meas1/';
listing=dir(folder);
j=1;
M=struct;
for k=1:size(listing ,1)
    if(listing(k).name(1) == 'f')
        Name=listing(k).name;
        temp= csvread(strcat(folder,Name),0,2)';
        M(j).data=temp;%(:,1:700);
        freq(j)=str2double(Name(3:13));
        j=j+1;
    end
end
% for k=1:size(listing ,1)
%     if(listing(k).name(1) == '_')
%         Name=listing(k).name;
%         temp= csvread(strcat(folder,Name),0,0)';
%         M(j).data=temp;%(:,1:700);
%         j=j+1;
%     end
% end
offset=floor(freq(1));
%%
% schwellwert=1500;
% 
% figure
% for k=130%10:size(M,2)
%     temp1=M(k-1).data;
%     temp2=M(k).data;
%     temp3=abs(temp1-temp2);
%     temp3(temp3<schwellwert)=0;
%     imagesc(temp3);
%     hold on
%     waitforbuttonpress
%     pause(0.1)
%     k
% end
% 
% %%
% 
% for k=1:size(M,2)
%     temp=M(k).data;
%     xS=size(temp,1);
%     yS=size(temp,2);
%     x=linspace(1,xS,xS)';
%     for l=1:yS
%         y=temp(:,l);
%         f=sum(x.*y)*1/sum(y);
%         heavyside(k,l)=f;
%     end
% 
% end
% %
% figure
% for k=128:132%k=2:size(M,2)
%     deltafkt(k-1,:)=abs(heavyside(k-1,:)-heavyside(k,:));
%     abs(heavyside(k-1,:)-heavyside(k,:));
%     subplot(2,2,1)
%     plot(deltafkt(k-1,:));
%     subplot(2,2,2)
%     plot(heavyside(k-1,:))
%     subplot(2,2,3)
%     imagesc(M(k-1).data)
%     subplot(2,2,4)
%     imagesc(M(k).data)
%     k
%     figure 
%     plot(deltafkt(k-1,:))
%     waitforbuttonpress
%     
% end
% % Vert alt
% x1=M(4).data(:,1);
% y1=M(4).data(:,2);
% x2=M(1).data(:,1);
% y2=M(1).data(:,2);
% x3=M(2).data(:,1);
% y3=M(2).data(:,2);
% x4=M(3).data(:,1);
% y4=M(3).data(:,2);
% % x5=M(2).data(:,1);
% % y5=M(2).data(:,2);
% figure
% plot(x1,y1,x2,y2,x3,y3,x4,y4)
% xlabel('wavelength / nm')
% ylabel('delay / ps')
% h =legend('initial dispersion','compensation of 2nd order','compensation of 1st order','compensation of 1st order');
% v = get(h,'title');
% set(v,'string','iterative improvement steps');
% figure
% plot(x3,y3,'k--',x4,y4,'k')
% ylim([-10 10])
% xlabel('wavelength / nm')
% ylabel('delay / ps')
% waitforbuttonpress

%% Vert2

figure
% 
x1=M(3).data(:,1);
y1=M(3).data(:,2);
x2=M(2).data(:,1);
y2=M(2).data(:,2);
P = polyfit(x1,y1,1);
yfit = P(1)*x1+P(2);
P2 = polyfit(x2,y2,1);
yfit2 = P2(1)*x2+P2(2);
l=plot(x1, y1,'k',x2, y2,'k',x1,yfit-5,'k:',x2,yfit2-5,'k:')
l(1).LineWidth = 1; 
l(2).LineWidth = 2.5;
l(3).LineWidth = 1; 
l(4).LineWidth = 2.5;
xlabel('wavelength / nm')
ylabel('delay / ps')
legend('uncompensated','uncompensated','linear order(compensated)','linear order(uncompensated)')
yresid=y1-yfit;
yresid2=y2-yfit2;
figure
l=plot (x1, y1,'k',x2, y2,'k',x1,yresid,'k:',x2,yresid2,'k:')
ylim([-6 3])
l(1).LineWidth = 1; 
l(2).LineWidth = 2.5;
l(3).LineWidth = 1; 
l(4).LineWidth = 2.5;
legend([l(3),l(4)],'quadratic residual(compensated)','quadratic residual(uncompensated)')
xlabel('wavelength / nm')
ylabel('delay / ps')
%     p=polyfit(M(2).data(:,1),M(2).data(:,2),3);
%     plot(M(2).data(:,1),polyval(M(2).data(:,1),p(1)))
%     hold on
%     plot(M(2).data(:,1),polyval(M(2).data(:,1),p(2)))
%     hold on
%     plot(M(2).data(:,1),polyval(M(2).data(:,1),p(3)))
%     plot(M(3).data(:,1),M(3).data(:,2))
%     xlabel('Sample number correlating to a specific Wavelength')
%     ylabel('Arbitrary Intensity')


%%
figure
imagesc(M(1).data)
ax = gca;
% load('MyColormaps','mycmap')
colormap(hot)
xlabel('Sample number correlating to a specific Wavelength')
ylabel('Arbitrary Intensity')
colorbar
figure
imagesc(M(90).data)
ax = gca;
% load('MyColormaps','mycmap')
colormap(hot)
xlabel('Sample number correlating to a specific Wavelength')
ylabel('Arbitrary Intensity')
colorbar
figure
imagesc(M(95).data)
ax = gca;
% load('MyColormaps','mycmap')
colormap(hot)
xlabel('Sample number correlating to a specific Wavelength')
ylabel('Arbitrary Intensity')
colorbar


figure 
imagesc(M(100).data)
ax = gca;
% load('MyColormaps','mycmap')
colormap(hot)
xlabel('Sample number correlating to a specific Wavelength')
ylabel('Arbitrary Intensity')
colorbar

%%
% temp= csvread(strcat(folder,listing(4).name,0,0));
% figure
% plot(temp(1,20:end),temp(2,20:end),'k')
% xlabel('Wavelength in [nm]')
% ylabel('Delay in [ps]')
% xlim([1010,1100])


% %%
% [wert,i1]=max(deltafkt,[],2);
% [deltafkt1,i2]=sort(deltafkt,2);
% %i2=i2(:,995:1000);
% 
% figure
% s=1./freq;
% ps=(s-s(100))*1e12;
% plot(i2(:,995:1000),ps(2:end),'ro')
% %ylim([floor(freq(1)) ceil(freq(200))])
% [x,y] = ginput(2)
% toc