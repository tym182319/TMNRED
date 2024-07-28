clear
clc
m = 1;
data = [];
path ='D:\Data\';
for d = 1:30
    switch d
        case 1
            date = '0509';
        case 2
            date = '0510';
        case 3
            date = '0511';
        case 4
            date = '0512';
        case 5
            date = '0513';
        case 6
            date = '0514';
        case 7
            date = '0515';
        case 8
            date = '0516';
        case 9
            date = '0518';            
        case 10
            date = '0519';
        case 11
            date = '0521';
        case 12
            date = '0615';
        case 13
            date = '0616';
        case 14
            date = '0617';
        case 15
            date = '0624';
        case 16
            date = '0705';
        case 17
            date = '0827';
        case 18
            date = '05112';
        case 19
            date = '05132';            
        case 20
            date = '05142';
        case 21
            date = '05143';
        case 22
            date = '05152';
        case 23
            date = '05172';
        case 24
            date = '05182';
        case 25
            date = '05212';
        case 26
            date = '06162';
        case 27
            date = '06163';
        case 28
            date = '06242';
        case 29
            date = '08241';            
        case 30
            date = '08242';            
    end
    for blc = 1:5
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
save('Data1201.mat','data','label','subject');