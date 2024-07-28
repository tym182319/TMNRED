clear
clc
% Step1 Import data
eeglab;
close all
date = '08242';
blc = 5;
filepath = strcat('D:\Data','\',date,'\',num2str(blc),'\'); % 需修改
EEG = pop_importNeuracle({'data.bdf','evt.bdf'}, filepath);
% EEG = pop_importNeuracle({'data.bdf','data.1.bdf','evt.bdf'}, filepath);

EEG = eeg_checkset(EEG);

% Step2 Adjust Channels and rereference to average
% remove channels and load channel locations
EEG = pop_select(EEG, 'nochannel', {'A1','A2'});
EEG = pop_chanedit(EEG, 'lookup', 'C:\Program Files\MATLAB\R2018b\toolbox\eeglab\plugins\dipfit\standard_BESA\standard-10-5-cap385.elp'); % 需修改
% remove unnecessary part
L = size(EEG.data,2);
EEG = eeg_eegrej(EEG, [0 EEG.event(1,1).latency-1000; EEG.event(length(EEG.event)).latency+5000 L]);
EEG = eeg_checkset(EEG);
% interpolate bad channels
[~, ind, ~, ~] = pop_rejchan(EEG, 'elec', (1:30), 'threshold', 2, 'norm', 'on', 'measure', 'spec');
EEG = pop_interp(EEG, ind, 'spherical');
EEG = eeg_checkset(EEG);
% rereference to average
EEG = pop_reref(EEG, []);
EEG = eeg_checkset(EEG);

% Step3 Filter and resample 
EEG = pop_eegfiltnew(EEG, 'locutoff', 0.5);
EEG = eeg_checkset(EEG);
EEG = pop_eegfiltnew(EEG, 'hicutoff', 80);
EEG = eeg_checkset(EEG);
EEG  = pop_basicfilter( EEG, 1:30, 'Boundary', 'boundary', 'Cutoff', 50, 'Design', 'notch', 'Filter', 'PMnotch', 'Order', 180, 'RemoveDC', 'on' );
EEG = pop_resample(EEG, 200);
EEG = eeg_checkset(EEG);

% Step4 Run ICA
interp_array = ind;
ica_array = (1:1:30);
for i = 1:length(interp_array)
    ica_array(ica_array==interp_array(i)) = [];
end
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on','chanind',ica_array);
EEG = eeg_checkset(EEG);

% Step5 Select ICA components
% EEG = pop_selectcomps(EEG, (1:10)); 
EEG = pop_iclabel(EEG, 'default');
pop_viewprops( EEG, 0, [1:10], {'freqrange', [2 80]}, {}, 1, 'ICLabel' )
EEG = pop_icflag(EEG, [NaN NaN;0.8 1;0.6 1;0.6 1;0.6 1;0.6 1;0.7 1]); % brain muscle eye heart linenoise channelnoise other 

%%
% Step6 Sub ICA components
% Please step run here
EEG = pop_subcomp(EEG);
EEG = eeg_checkset(EEG);

% Step7 Save
EEG.setname = strcat(date,'-',num2str(blc),' file');
pop_saveset(EEG, 'filename', (strcat(date,'-',num2str(blc),'.set')), 'filepath', filepath); 
close all