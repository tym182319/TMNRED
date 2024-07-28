%% Calculate_RP
clear
clc
path = 'D:\正式数据\';
Fs = 200;
nlab = 1:10;
nlab2 = 11:15;
nolab = 16:50;
nlab = nlab+14;
nlab2 = nlab2+14;
nolab = nolab+14;
% 选择关注的时间段
tm = 4;
switch tm
    case 1
        sth = 0*Fs; % 0s
        lth = 0.5*Fs; % 0.5s
    case 2
        sth = 0.5*Fs; % 0.5s
        lth = 1*Fs; % 1s
    case 3
        sth = 1*Fs; % 1s
        lth = 1.5*Fs; % 1.5s
    case 4
        sth = 1.5*Fs; % 1.5s
        lth = 2*Fs; % 2s
end
for d = 1:30
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
        case 20
            date = '0308';
        case 21
            date = '0310';
        case 22
            date = '0311';
        case 23
            date = '0313';
        case 24
            date = '0314';
        case 25
            date = '03181';
        case 26
            date = '03182';
        case 27
            date = '03191';
        case 28
            date = '03192';
        case 29
            date = '0320';
        case 30
            date = '0321';
    end
    for blc = i:8
        filepath = strcat(path,date,'\',num2str(blc),'\');
        EEG = pop_loadset('filename',(strcat(date,'-',num2str(blc),'.set')),'filepath',filepath);
        EEG = eeg_checkset(EEG);
        Chaloc = EEG.chanlocs;
        j = 5;
        switch j
            case 1
                band = [1 4];
            case 2
                band = [4 8];
            case 3
                band = [8 13];
            case 4
                band = [13 30];
            case 5
                band = [30 80];
        end
        for i = 2:length(EEG.event)
            LL(1,i-1) = str2double(EEG.event(1,i).type);
            LL(2,i-1) =  EEG.event(1,i).latency;
        end
        %
        for i = 1:length(nlab)
            a = find(LL(1,:) == nlab(i));
            nl(i,1) = round(LL(2,a))+sth;
            nl(i,2) = round(LL(2,a))+lth;
        end
        for i = 1:length(nlab2)
            c = find(LL(1,:) == nlab2(i));
            nl1(i,1) = round(LL(2,c))+sth;
            nl1(i,2) = round(LL(2,c))+lth;
        end
        for i = 1:length(nolab)
            b = find(LL(1,:) == nolab(i));
            nn(i,1) = round(LL(2,b))+sth;
            nn(i,2) = round(LL(2,b))+lth;
        end
        %
        for c = 1:length(nlab)
            for i = 1:30
                eeg = EEG.data(i,nl(c,1):nl(c,2));
                eeg = detrend(eeg);
                N = length(eeg);
                nfft = 2^nextpow2(N); % the number of FFT points
                [pxx,f] = pyulear(eeg,10,nfft,Fs);
                psd = bandpower(pxx, f, band, 'psd');
                psd6 = bandpower(pxx, f, [1 80], 'psd');
                rp1(c,i) = psd/psd6;
            end
        end
        clearvars pxx f psd psd6
        Rp1 = mean(rp1,1);
        %
        for c = 1:length(nolab)
            for i = 1:30
                eeg = EEG.data(i,nn(c,1):nn(c,2));
                eeg = detrend(eeg);
                N = length(eeg);
                nfft = 2^nextpow2(N); % the number of FFT points
                [pxx,f] = pyulear(eeg,10,nfft,Fs);
                psd = bandpower(pxx, f, band, 'psd');
                psd6 = bandpower(pxx, f, [1 80], 'psd');
                rp2(c,i) = psd/psd6;
            end
        end
        clearvars pxx f psd psd6
        Rp2 = mean(rp2,1);
        %
        for c = 1:length(nlab2)
            for i = 1:30
                eeg = EEG.data(i,nl1(c,1):nl1(c,2));
                eeg = detrend(eeg);
                N = length(eeg);
                nfft = 2^nextpow2(N); % the number of FFT points
                [pxx,f] = pyulear(eeg,10,nfft,Fs);
                psd = bandpower(pxx, f, band, 'psd');
                psd6 = bandpower(pxx, f, [1 80], 'psd');
                rp3(c,i) = psd/psd6;
            end
        end
        Rp3 = mean(rp3,1);
        save(strcat(filepath,'R',num2str(tm),num2str(j),'.mat'),'Rp1','Rp2','Rp3')
        clearvars Rp1 Rp2 Rp3 rp1 rp2 rp3 psd psd6 pxx f eeg LL nl nll nn EEG
    end
end
%%
m = 1;
for d = 1:30
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
        case 20
            date = '0308';
        case 21
            date = '0310';
        case 22
            date = '0311';
        case 23
            date = '0313';
        case 24
            date = '0314';
        case 25
            date = '03181';
        case 26
            date = '03182';
        case 27
            date = '03191';
        case 28
            date = '03192';
        case 29
            date = '0320';
        case 30
            date = '0321';
    end
    blcs = 8;
    for blc = i:blcs
        filepath = strcat(path,date,'\',num2str(blc),'\');
        gpath = strcat(filepath,'R21.mat');
        load(gpath)
        Pg1(m,:) = Rp1;
        Pg2(m,:) = Rp2;
        Pg3(m,:) = Rp3;
        m  = m + 1;
    end
end
r1 = mean(Pg1,1);
r2 = mean(Pg2,1);
r3 = mean(Pg3,1);
save(strcat(path,'\','Rp',num2str(tm),num2str(j),'.mat'),'r1','r2','r3')

%%
% 可单独load数据文件夹下Rp.mat文件绘制整体
range = [0.26 0.36];
load(strcat(path,'Chaloc.mat'))
subplot(2,3,1)
s(1)=topoplot(r1,Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
title('TargetBegin','fontsize',20,'fontweight','bold');

subplot(2,3,2)
s(2)=topoplot(r3,Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
title('TargetOther','fontsize',20,'fontweight','bold');

subplot(2,3,3)
s(3)=topoplot(r2,Chaloc);
caxis(range)
cb = colorbar('fontsize',16,'fontweight','bold');
title('NonTarget','fontsize',20,'fontweight','bold');

subplot(2,3,4)
s(4)=topoplot(r1-r2,Chaloc);
caxis([-0.02 0.02])
cb = colorbar('fontsize',16,'fontweight','bold');
title('Tb-Nt','fontsize',20,'fontweight','bold');

subplot(2,3,5)
s(5)=topoplot(r3-r2,Chaloc);
caxis([-0.02 0.02])
cb = colorbar('fontsize',16,'fontweight','bold');
title('To-Nt','fontsize',20,'fontweight','bold');

subplot(2,3,6)
s(6)=topoplot(r1-r3,Chaloc);
caxis([-0.02 0.02])
cb = colorbar('fontsize',16,'fontweight','bold');
% cb.Title.String = '%';
title('Tb-To','fontsize',20,'fontweight','bold');