clear
clc
path = 'D:\正式数据\';
m = 1;
load(strcat(path,'Chaloc.mat'))
for d = 1:1
    i = 1;
    switch d
        case 1
            date = '1108';
%         case 2
%             date = '1115';
%         case 3
%             date = '1116';
%         case 4
%             date = '1117';
%             i = 2;
%         case 5
%             date = '1118';
%         case 6
%             date = '1121';
%         case 7
%             date = '1123';
%         case 8
%             date = '1126';
%         case 9
%             date = '1202';
%         case 10
%             date = '1209';
%         case 11
%             date = '1212';
%         case 12
%             date = '0209';
%         case 13
%             date = '0223';
%         case 14
%             date = '0228';
%         case 15
%             date = '0303';
%         case 16
%             date = '0304';
%         case 17
%             date = '0306';
%         case 18
%             date = '03071';
%         case 19
%             date = '03072';
    end
    blcs = 8;
    for blc = i:blcs
        filepath = strcat(path,date,'\',num2str(blc),'\');
        gpath = strcat(filepath,'R25.mat');
        load(gpath)
        Pg1(m,:) = Rp1; % bt
        Pg2(m,:) = Rp2; % nt
        Pg3(m,:) = Rp3; % ot
        m  = m + 1;
    end
end
%%
% 140-500
% chns = [2 3 5 6 7 9 10 11 15 19 24 25 26 28 29 30];
chns = 1:30;
% 500-1500
% chns = [1 2 4 5 6 7 10 11 15 16 24];

for i = 1:length(chns)
    Chaloc(1,chns(1,i)).labels
    Pss(:,1) = Pg1(:,chns(1,i));
    Pss(:,2) = Pg2(:,chns(1,i));
    Pss(:,3) = Pg3(:,chns(1,i));
    [h1(i),p1(i)] = ttest(Pss(:,1),Pss(:,2),0.05);
%     [h2(i),p2(i),ci] = ttest2(Pss(:,1),Pss(:,3),0.05);
    [h3(i),p3(i)] = ttest(Pss(:,2),Pss(:,3),0.05);
end
