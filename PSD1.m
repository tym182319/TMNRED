%% Calculate_PSD
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
sth = 0*Fs; % 0.5s
lth = 0.5*Fs; % 1.5s
for d = 1:19
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
    for blc = i:8
        filepath = strcat(path,date,'\',num2str(blc),'\');
        EEG = pop_loadset('filename',(strcat(date,'-',num2str(blc),'.set')),'filepath',filepath);
        EEG = eeg_checkset(EEG);
        Chaloc = EEG.chanlocs;
        j = 6;
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
            case 6
                band = [1 80];
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
                sub_psd1(c,i) = psd;
            end
        end
        clearvars pxx f psd
        Psd1 = mean(sub_psd1,1);
        %
        for c = 1:length(nolab)
            for i = 1:30
                eeg = EEG.data(i,nn(c,1):nn(c,2));
                eeg = detrend(eeg);
                N = length(eeg);
                nfft = 2^nextpow2(N); % the number of FFT points
                [pxx,f] = pyulear(eeg,10,nfft,Fs);
                psd = bandpower(pxx, f, band, 'psd');
                sub_psd2(c,i) = psd;
            end
        end
        clearvars pxx f psd
        Psd2 = mean(sub_psd2,1);
        %
        for c = 1:length(nlab2)
            for i = 1:30
                eeg = EEG.data(i,nl1(c,1):nl1(c,2));
                eeg = detrend(eeg);
                N = length(eeg);
                nfft = 2^nextpow2(N); % the number of FFT points
                [pxx,f] = pyulear(eeg,10,nfft,Fs);
                psd = bandpower(pxx, f, band, 'psd');
                sub_psd3(c,i) = psd;
            end
        end
        Psd3 = mean(sub_psd3,1);
        save(strcat(filepath,'G.mat'),'Psd1','Psd2','Psd3')
        clearvars Psd1 Psd2 Psd3 sub_psd1 sub_psd2 sub_psd3 psd pxx f eeg LL nl nll nn EEG
    end
end
%% Block出图
% 可单独load对应文件夹下G.mat文件绘制单个block
range = [5 15];
subplot(1,4,1)
s(1)=topoplot(10*log10(Psd1),Chaloc);
caxis(range)
cb = colorbar('fontsize',13,'fontweight','bold');
cb.Title.String = 'dB';
title('Target-begin','fontsize',18,'fontweight','bold');
subplot(1,4,2)
s(2)=topoplot(10*log10(Psd2),Chaloc);
caxis(range)
cb = colorbar('fontsize',13,'fontweight','bold');
cb.Title.String = 'dB';
title('Target-other','fontsize',18,'fontweight','bold');
subplot(1,4,3)
s(3)=topoplot(10*log10(Psd3),Chaloc);
caxis(range)
cb = colorbar('fontsize',13,'fontweight','bold');
cb.Title.String = 'dB';
title('non-Target','fontsize',18,'fontweight','bold');
subplot(1,4,4)
s(4)=topoplot(10*log10(Psd1)-10*log10(Psd2),Chaloc);
caxis([-1.5 1.5])
cb = colorbar('fontsize',13,'fontweight','bold');
cb.Title.String = 'dB';
title('Tb-nT','fontsize',18,'fontweight','bold');
