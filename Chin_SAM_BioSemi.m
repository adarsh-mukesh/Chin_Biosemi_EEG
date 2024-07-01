clear all; close all hidden; clc;

[RP1, RP2, RX8, PA1,PA2,PA3,PA4,tdt_info] = tdt_init(99);
fs =48828.125;

%% From Rav
circuit_RP1 = 'Play_EEG.rcx';
circuit_RP2 = 'Play_EEG_RP2_2.rcx';
circuit_RX8 = 'RX8_triggers.rcx';

invoke(RP1,'Halt');
invoke(RP1,'ClearCOF');
invoke(RP1,'LoadCOF',circuit_RP1);

invoke(RP2,'Halt');
invoke(RP2,'ClearCOF');
invoke(RP2,'LoadCOF',circuit_RP2);

invoke(RX8,'Halt');
invoke(RX8,'ClearCOF');
invoke(RX8,'LoadCOF',circuit_RX8);

invoke(RP1,'Run');
invoke(RP2,'Run');
invoke(RX8,'Run');

%mixer selector
invoke(RP1,'SetTagVal','Select_L',1);
invoke(RP1,'SetTagVal','Connect_L',2);
invoke(RP2,'SetTagVal','Select_R',5);
invoke(RP2,'SetTagVal','Connect_R',3);

invoke(PA1,'SetAtten',0);
invoke(PA2,'SetAtten',0);
invoke(PA3,'SetAtten',25);
invoke(PA4,'SetAtten',25);

%% start playing
invoke(RX8, 'SetTagVal', 'trigval',253);
invoke(RP1, 'SetTagVal', 'onsetdel',100);
invoke(RP1, 'SoftTrg', 1);
try
    % Loading random generator seed and state so that anything generated
    % randomly will be regenerated with the same realization everytime
    load('s.mat');
    rng(s);
    
    % Initialize play circuit
    %     fig_num=99;
    %     USB_ch=1;
    %     IAC = -1;
    %     FS_tag = 3;
    %     Fs = 48828.125;
    %Comment in
    %[f1RZ,RZ,FS]=load_play_circuit(FS_tag,fig_num,USB_ch,0,IAC);
    
    % Experiment parameters
    %ntrials = 150*2*3; % This is the number of transitions
    %     ntrials = 1500;
    ntrials = 800;
    % ntrials should be a multiple of number of values in tonesperseq
    level = 80;
    isi = 0.75; % Average interstimulus interval (only approx guarenteed)
    
    
    % Some cushion for time taken to write each trial to buffer
    % Stim has to be short enough to be written in this time, typically 50
    % ms should be enough for most stims.
    bufferwritetime = 0.02;
    jitter = 0.05; % Maximum value of uniformly distributed jitter in ISI
    
    %Comment in
    % Send trigger to EEG to start saving
    %     invoke(RZ, 'SetTagVal', 'trigval',253);
    %     invoke(RZ, 'SoftTrg', 6);
    
    % Wait at least 3 seconds before presenting any stims (e.g., for
    % filter transients, etc.)
    pause(3.0);
    
    % Load or generate a stimulus with the intent of playing it in both
    % polarities. Replace with other stims here.
    % Must be mono (i.e., size Nsamples-by-1) with a variable called 'y'.
    % This can also be generated within the main loop if each trial has a
    % different stimulus, but depending on stim generation code, in some
    % cases that might slowdown the overall timing (but not affect the
    % synchrony of triggers).
    % The sampling rate has to Fs = 48828.125 Hz based on earlier hardcoded
    % properties of this template script.
    fs = 48828.125;
    
    %These are rough durations...to get zero crossings, we will round to
    %nearest cycle
    
    fc=[2000 4000];
    fm=[ 4 40];
    modDepth =1;
    dur = 1; 
    amp=1;
 
    %
    [x_AC, ~] = make_SAM(fc(1), fm(1), fs, modDepth, dur, amp, [], []);
    [x_AB, ~] = make_SAM(fc(1), fm(2), fs, modDepth, dur, amp, [], []);

    
    x_AB = scaleSound(x_AB);
    x_AC = scaleSound(x_AC);
    
    
    % Setup triggers 1 = -pi/2, 2 = pi/2, upper one is pos polarity
    triglist = randi(2,ntrials,1);
    

    % Using jitter to make sure that background noise averages out across
    % trials. We use jitter that is random between 0 and 'jitter' seconds.
    % Average duration added by the jitter is jitter/2 seconds
    jitlist = rand(ntrials, 1)*jitter;
    %jitlist = zeros(ntrials*(mean(tonesperseq)+1),1);
    
    if isi < 0.05
        error('Interstimulus interval too short, cannot continue');
    end
    
    %NEED CALIBRATION??
    %     stim.attenR = 20;
    %     stim.attenL = 20;
    
    % Keep track of time if needed
    tstart = tic;
    for j = 1:ntrials
        
        stimTrigger = triglist(j);
        %p_pol =  round(rand(1)); %1 for plus, 0 for minus
        
        if mod(stimTrigger,2)==0  
            x = x_AB;
            dur_p = length(x_AB)/fs;
        else
            x = x_AC;
            dur_p = length(x_AC)/fs;
        end
        
%         if p_pol == 0
%             x = -x;
%         end
%         
        y = x;
        
        stimrms = rms(y);
        
        chanL = y;
        chanR = y;
        
    %    stimTrigger = stimTrigger + p_pol*2; 
        
        jit = jitlist(j);
        
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
        
        invoke(RP1, 'SetTagVal', 'nsamps', resplength);
        invoke(RP1, 'WriteTagVEX','datainR',0,'F32',chanR);
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
        fprintf(1,'Trial = %d/%d\n', j, ntrials);
        pause(dur_p + isi + jit);
        disp(stimTrigger);
        
        invoke(RP1,'ZeroTag','datainL');
        invoke(RP1,'ZeroTag','datainR');
    end
    toc(tstart); % Just to help get a sense of how long things really take
    %not working...need to update circuit file
    invoke(RX8, 'SetTagVal', 'trigval', 254);
    invoke(RP1, 'SoftTrg', 6);
    
    % Have at least 3 seconds of no stim EEG data at the end
    pause(3.0);
    % Send trigger to EEG computer asking it to stop saving
    %     invoke(RZ, 'SetTagVal', 'trigval', 254);
    %     invoke(RZ, 'SoftTrg', 6);
    
    %     close_play_circuit(f1RZ,RZ);
    fprintf(1,'\n Done with data collection!\n');
catch me
    %Comment in
    %     close_play_circuit(f1RZ,RZ);
    rethrow(me);
end
