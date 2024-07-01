%clear all; close all hidden; clc;

[RP1, RP2, RX8, PA1,PA2,PA3,PA4,tdt_info] = tdt_init(99);
fs =48828.125;
global PROTOCOL RX8
PROTOCOL = 'EEG_BioSemi';
%data_fold_name ='C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\invCalibrationFiles\calibration\calib_data\123_20240626_EEGcalibFiles';
data_fold_name=NelData.File_Manager.dirname ;
addpath('objects');

%% From Rav
circuit_RP1 = 'C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\objects\Play_EEG_RP2_1.rcx';
circuit_RP2 = 'C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\objects\Play_EEG_RP2_2.rcx';
circuit_RX8 = 'C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\objects\RX8_triggers.rcx'; % set in set_inv_filter.m

invoke(RP1,'Halt');
invoke(RP1,'ClearCOF');
invoke(RP1,'LoadCOF',circuit_RP1);

invoke(RP2,'Halt');
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF',circuit_RP2)

invoke(RX8,'Halt');
invoke(RX8,'ClearCOF');
invoke(RX8,'LoadCOF',circuit_RX8);

invoke(RP1,'Run');
invoke(RP2,'Run');
invoke(RX8,'Run');

% set to all-pass to start (maybe not needed)
filttype = {'allpass','allpass'};
RawCalibPicNum = 1;
temp=pwd;
invfilterdata = set_invFilter(filttype, RawCalibPicNum, true, data_fold_name);
cd(temp) 

% NEED THIS, not all pass once all running 
% set to inverse
filttype = {'inversefilt','inversefilt'};
invfiltdata = set_invFilter(filttype,RawCalibPicNum,false, data_fold_name);
cd(NelData.File_Manager.parent_dir)
    %%%  need to copy findPics.m from NEL
    
    
% protect the ears while adjusting params
invoke(PA1,'SetAtten',120);
invoke(PA2,'SetAtten',120);
invoke(PA3,'SetAtten',120);
invoke(PA4,'SetAtten',120);

%mixer selector    % RP2_1 is just book-keeping
% invoke(RP1,'SetTagVal','Select_L',1);
% invoke(RP1,'SetTagVal','Connect_L',2);
% invoke(RP2,'SetTagVal','Select_R',5);
% invoke(RP2,'SetTagVal','Connect_R',3);
invoke(RP1,'SetTagVal','Select_L',5);    % RP2_2_Ch2 (datainL) goes to Lselect
invoke(RP1,'SetTagVal','Connect_L',2);   % pass through on Left (datainL)
invoke(RP2,'SetTagVal','Select_R',0);    % RP2_2_Ch1 (datainR) goes to Rselect
invoke(RP2,'SetTagVal','Connect_R',1);   % pass through on Right (datainR)


%% start playing
invoke(RX8, 'SetTagVal', 'trigval',253);
invoke(RP2, 'SetTagVal', 'onsetdel',100);
invoke(RP1, 'SoftTrg', 1);

try
    % Loading random generator seed and state so that anything generated
    % randomly will be regenerated with the same realization everytime
    load('s.mat');
    rng(s);
    
   
    level = 100;
    isi = 0.75; % Average interstimulus interval (only approx guarenteed)
    
    
    % Some cushion for time taken to write each trial to buffer
    % Stim has to be short enough to be written in this time, typically 50
    % ms should be enough for most stims.
    bufferwritetime = 0.02;
    jitter = 0.05; % Maximum value of uniformly distributed jitter in ISI
    
   
    pause(3.0);
    fs = 48828.125;
    %%% select stimulus in this part - edit stim_import code if you add a
    %%% new stimulus
    list={'2 STM ACC','GDT stim 4T3G'};
    stim_ord=listdlg('PromptString',{'Select stim'},'SelectionMode','single','ListString',list);
    switch stim_ord
        case 1
            [stim_vec,triglist,ntrials]=stim_import('STM_ACC');
        case 2
            [stim_vec,triglist,ntrials]=stim_import('GDT_human');
    end
    db_tp=inputdlg('What dB SPL do you want to play?');
    db_tp=str2num(db_tp{1,1});
     
    all_filt=[];
    all_orig=[];
    for ii=1:length(stim_vec)
        % we need BB calibration done in NEL convetion - see Satya code, or more
        % recent??
        % 1. check [-1,1] to be sure no clipping will happen
        % 2. compute atten for desired SPL (Saty code) [use inv_Calib file)
        % 3. get inv_filt code into here and running [copy from
        % calibration)
        % DONE?
        
        [filteredSPL, originalSPL]= get_SPL_from_calib(stim_vec{ii,1}, fs, a1.CalibData, 0);
        all_filt=[all_filt; filteredSPL];
        all_orig=[all_orig; originalSPL];
        
    end
        
    
    
    % Using jitter to make sure that background noise averages out across
    % trials. We use jitter that is random between 0 and 'jitter' seconds.
    % Average duration added by the jitter is jitter/2 seconds
    jitlist = rand(ntrials, 1)*jitter;
    
    
    if isi < 0.05
        error('Interstimulus interval too short, cannot continue');
    end
    
    %NEED CALIBRATION??
    %     stim.attenR = 20;
    %     stim.attenL = 20;
    
    % Keep track of time if needed
    tstart = tic;
    for jj=1:length(triglist)
        stimTrigger=triglist(jj);
        x=stim_vec{stimTrigger,1};
        dur_p=length(x)/fs;
        atn=all_filt(stimTrigger)-db_tp;
        invoke(PA1,'SetAtten',0);
        invoke(PA2,'SetAtten',0);
        invoke(PA3,'SetAtten',atn);
        invoke(PA4,'SetAtten',atn);

        
      
        y = x;
        
        stimrms = rms(y);
        
        chanL = 0.1*y;
        chanR = y;
        
        %    stimTrigger = stimTrigger + p_pol*2;
        
        jit = jitlist(jj);
        
        stimlength = numel(y); % Recalculate, just in case
        resplength = stimlength+round(isi*fs);
        %---------------------------------------------------------
        % Stimulus calibration calculations based on known
        % hardware and known .rcx circuit properties
        %---------------------------------------------------------
        % ER-2s give 100dB SPL for a 1kHz tone with a 1V-rms drive.
        % BasicPlay.rcx converts +/- 1 in MATLAB to +/- 5V at TDT
        % output, so you get 114 dB SPL for MATLAB rms of 1.
        %
        % So if we want a signal with rms of "stimrms" to be X dB,
        % then you have to attenuate in harwdware by below amount:
        
        % If switching to monaural, drop the unused ear by 120 dB flat
        % Also change overall stim level (because no loudness
        % summation)
        %             dropL = 114 - level + db(stimrms);
        %             dropR = 114 - level + db(stimrms); % Assumes diotic
        %
        %comment back in on NEL
        %             invoke(RZ, 'SetTagVal', 'trigval', stimTrigger);
        %             invoke(RZ, 'SetTagVal', 'nsamps', resplength);
        %             invoke(RZ, 'WriteTagVEX', 'datainR', 0, 'F32', chanR);
        %             invoke(RZ, 'WriteTagVEX', 'datainL', 0, 'F32', chanL);
        
%         invoke(RP2, 'SetTagVal', 'nsamps', resplength);
%         invoke(RP2, 'WriteTagVEX','datainR',0,'F32',chanR);
        
        figure(1); plot(chanL)
        figure(2); plot(chanR)
        
        
        invoke(RP2, 'SetTagVal', 'nsamps', resplength);
        invoke(RP2, 'WriteTagVEX','datainR',0,'F32',chanR);
        invoke(RP2, 'WriteTagVEX','datainL',0,'F32',chanL);
        invoke(RX8, 'SetTagVal','TrigVal',stimTrigger);
        
        %rc = PAset([0, 0, stim.attenR, stim.attenL]);
        %soundsc(chanR,fs);
        
        %write to buffer left ear
        %write to buffer right ear
        
        %setting analog attenuation L
        %             invoke(RZ, 'SetTagVal', 'attA', dropL);
        % %             %setting analog attenuation R
        %             invoke(RZ, 'SetTagVal', 'attB', dropR);
        
        

        % Just giving time for data to be written into buffer
        pause(bufferwritetime);
        
        %Start playing from the buffer:
        %             invoke(RZ, 'SoftTrg', 1); %Playback trigger
        invoke(RP1,'SoftTrg',1);
        fprintf(1,'Trial = %d/%d\n', jj, ntrials);
        pause(dur_p + isi + jit);
        disp(stimTrigger);
        
        invoke(RP2,'ZeroTag','datainL');
        invoke(RP2,'ZeroTag','datainR');
    end
    toc(tstart); % Just to help get a sense of how long things really take
    %not working...need to update circuit file
    invoke(RX8, 'SetTagVal', 'trigval', 254);
%     invoke(RP2, 'SoftTrg', 6);
    
    % Have at least 3 seconds of no stim EEG data at the end
    pause(3.0);
    % Send trigger to EEG computer asking it to stop saving
    %     invoke(RZ, 'SetTagVal', 'trigval', 254);
    %     invoke(RZ, 'SoftTrg', 6);
    
    %set back to allpass
    filttype = {'allpass','allpass'};
    RawCalibPicNum = NaN;
    invfilterdata = set_invFilter(filttype, RawCalibPicNum, true);
    
    close_circuit_nel2(RP1, RP2, RX8);
    fprintf(1,'\n Done with data collection!\n');
catch me
    %Comment in
    close_circuit_nel2(RP1, RP2, RX8);
    rethrow(me);
end
