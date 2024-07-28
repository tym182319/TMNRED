%% Plot_PSD_participant
clear
clc
path = 'D:\正式数据\';
for d = 1:19
    m = 1;
    i = 1;
    switch d
        case 1
            date = '1108';
        case 2
            date = '1115';
        case 3
            date = '1116';
        case 4
            date = '1117';
            i = 2;
        case 5
            date = '1118';
        case 6
            date = '1121';
        case 7
            date = '1123';
        case 8
            date = '1126';
        case 9
            date = '1202';
        case 10
            date = '1209';
        case 11
            date = '1212';
        case 12
            date = '0209';
        case 13
            date = '0223';
        case 14
            date = '0228';
        case 15
            date = '0303';
        case 16
            date = '0304';
        case 17
            date = '0306';
        case 18
            date = '03071';
        case 19
            date = '03072';
    end
    blcs = 8;
    for blc = i:blcs
        filepath = strcat(path,date,'\',num2str(blc),'\');
        gpath = strcat(filepath,'G.mat');
        load(gpath)
        Pg1(m,:) = Psd1;
        Pg2(m,:) = Psd2;
        Pg3(m,:) = Psd3;
        m  = m + 1;
    end
    g1 = mean(Pg1,1);
    g2 = mean(Pg2,1);
    g3 = mean(Pg3,1);
    save(strcat(path,date,'\','P.mat'),'g1','g2','g3')
end


%%
% 可单独load对应文件夹下P.mat文件绘制单个被试
range = [12 18];
load(strcat(path,'Chaloc.mat'))
subplot(2,3,1)
s(1)=topoplot(10*log10(g1),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('TargetBegin','fontsize',20,'fontweight','bold');
subplot(2,3,2)
s(2)=topoplot(10*log10(g3),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('TargetOther','fontsize',20,'fontweight','bold');
subplot(2,3,3)
s(3)=topoplot(10*log10(g2),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('NonTarget','fontsize',20,'fontweight','bold');
% subplot(2,4,4)
% s(4)=topoplot(5*log10(g1)+5*log10(g3)-10*log10(g2),Chaloc);
% caxis([-1.5 1.5])
% cb = colorbar('fontsize',16,'fontweight','bold');
% cb.Title.String = 'dB';
% title('T-nT','fontsize',20,'fontweight','bold');
subplot(2,3,4)
s(4)=topoplot(10*log10(g1)-10*log10(g2),Chaloc);
caxis([-1.5 1.5])
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('Tb-Nt','fontsize',20,'fontweight','bold');
subplot(2,3,5)
s(5)=topoplot(10*log10(g3)-10*log10(g2),Chaloc);
caxis([-1.5 1.5])
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('To-Nt','fontsize',20,'fontweight','bold');
subplot(2,3,6)
s(6)=topoplot(10*log10(g1)-10*log10(g3),Chaloc);
caxis([-1.5 1.5])
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('Tb-To','fontsize',20,'fontweight','bold');
