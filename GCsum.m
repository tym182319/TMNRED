clear
clc
path = 'D:\正式数据\';
type = 1;
td = 23;
GCs = zeros(30,30);
for d = 1:td
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
    end
    switch type
        case 1
            filename = strcat('GC-b2.mat');
        case 2
            filename = strcat('GC-o2.mat');
        case 3
            filename = strcat('GC-n2.mat');
    end
    filepath = strcat(path,date,'\');
    load(strcat(filepath,filename))
    GCs = GCs + GC.data;
end
GCs = GCs/td;
switch type
    case 1
        save(strcat(path,'GCb2.mat'),'GCs');
    case 2
        save(strcat(path,'GCo2.mat'),'GCs');
    case 3
        save(strcat(path,'GCn2.mat'),'GCs');
end