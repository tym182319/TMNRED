clear
clc
date = '1108';
path ='D:\正式数据\';
m = 1;
n = 1;
o = 1;
for blc = 1:8
    filepath = strcat(path,date,'\',num2str(blc),'\');
    EEG = pop_loadset('filename',(strcat(date,'-',num2str(blc),'z.set')),'filepath',filepath);
    EEG = eeg_checkset(EEG);
    data = EEG.data;
    for i = 1:length(EEG.event)
        Lb(1,i) = EEG.event(1,i).bini;
    end
    a = find(Lb(1,:) == 1);
    b = find(Lb(1,:) == 2);
    c = find(Lb(1,:) == 3);
    for i = 1:length(a)
        data1(:,:,m) = data(:,:,a(i));
        m = m + 1;
    end
    for i = 1:length(b)
        data2(:,:,n) = data(:,:,b(i));
        n = n + 1;
    end
    for i = 1:length(c)
        data3(:,:,o) = data(:,:,c(i));
        o = o + 1;
    end
    clearvars Lb a b c
end
save(strcat(path,date,'\',date,'-b.mat'),'data1')
save(strcat(path,date,'\',date,'-o.mat'),'data2')
save(strcat(path,date,'\',date,'-n.mat'),'data3')
