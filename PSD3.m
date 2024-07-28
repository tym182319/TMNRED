%% Plot_PSD_all
clear
clc
m = 1;
path = 'D:\正式数据\';
for d = 1:13
    switch d
        case 1
            date = '1108';
        case 2
            date = '1115';
        case 3
            date = '1116';
        case 4
            date = '1117';
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
    end
    filepath = strcat(path,date,'\');
    gpath = strcat(filepath,'P.mat');
    load(gpath)
    Pg1(m,:) = g1;
    Pg2(m,:) = g2;
    Pg3(m,:) = g3;
    m  = m + 1;
end
clearvars g1 g2 g3
g1 = mean(Pg1,1);
g2 = mean(Pg2,1);
g3 = mean(Pg3,1);

%%
range = [5 21];
load(strcat(path,'Chaloc.mat'))
subplot(1,5,1)
s(1)=topoplot(10*log10(g1),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('TargetBegin','fontsize',20,'fontweight','bold');
subplot(1,5,2)
s(2)=topoplot(10*log10(g3),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('TargetOther','fontsize',20,'fontweight','bold');
subplot(1,5,3)
s(3)=topoplot(10*log10(g2),Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('NonTarget','fontsize',20,'fontweight','bold');
subplot(1,5,4)
s(4)=topoplot(10*log10(g1)-10*log10(g2),Chaloc);
caxis([-1 1])
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('Tb-nT','fontsize',20,'fontweight','bold');
subplot(1,5,5)
s(5)=topoplot(10*log10(g1)-10*log10(g3),Chaloc);
caxis([-1 1])
cb = colorbar('fontsize',16,'fontweight','bold');
cb.Title.String = 'dB';
title('Tb-To','fontsize',20,'fontweight','bold');