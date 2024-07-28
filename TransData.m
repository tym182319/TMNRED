clear
clc
m = 1;
data = [];
path ='D:\正式数据\';
for d = 1:30
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
    for blc = 1:8
        filepath = strcat(path,date,'\',num2str(blc),'\');
        EEG = pop_loadset('filename',(strcat(date,'-',num2str(blc),'z.set')),'filepath',filepath);
        EEG = eeg_checkset(EEG);
        Data = EEG.data;
        Data = permute(Data,[3 1 2]);
        data = [data;Data];
        Event = EEG.event;
        
        for i = 1:size(Event,2)
            Label(i) = Event(i).bini;
            if Label(i) < 3
                label(m) = 1;
                subject(m) = d;
            else
                label(m) = 0;
                subject(m) = d;
            end
            m = m + 1;
        end
    end
end
save('Data0324.mat','data','label','subject');