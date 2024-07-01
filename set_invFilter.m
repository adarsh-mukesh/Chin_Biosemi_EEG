%Sprint 2023 | AS/MH/MP | Attempt to condense/cleanup what was formerly known as
%run_invCalib. A 2 channel version of this is soon to come.

%Good practice should save in each data file the filter type and relevant
%picture numbers. Important! Forces programs that call this function to previously
%have considered which calibration pic num to call. Otherwise will default
%to allstop.

%Change input to string
% 'allpass' = allpass
% 'allstop' = allstop
% 'inversefilt' = inverse calib based on specfied

%inversefilterdata:
% 1. CalibPICnum2use
% 2. filttype (cell array dim 2)
% 3. coefFileNum
% 4. b (cell array dim 2)


%TODO:
% - make sure to send b and b2 coefficients (only sending one to both
% chans)
% - check defaults for initial calibration when no file

function invfilterdata = set_invFilter(filttype, RawCalibPicNum, firstCalibFlag,full_fold_name)
global root_dir RX8 NelData

%handle no firstCalibFlag
if ~exist('firstCalibFlag','var')
    firstCalibFlag = false;
end

%% Error Checking
%check for 3 files
% -RawCalib for num passed
% -Coeffs
% -Inverse filter
errorFlag = false;
coefFileNum = RawCalibPicNum;
FPLflag = false; 

if strcmp(filttype,{'inversefilt_FPL', 'inversefilt_FPL'})
    FPLflag = true;
end

cd(full_fold_name) ;
%calib file is needed
if ~firstCalibFlag
    if ~prod(strcmp(filttype,{'allstop','allstop'}))
        %if Pic num not provided
        if ~exist('RawCalibPicNum','var')
            warndlg('Missing Calibration File Number in set_invFilter. Running allstop.','WARNING!!!','modal');
            errorFlag = true;
        else
            %Checking for valid raw calib file in data directory
            pic_str = sprintf('p%04d_%s',RawCalibPicNum,'*_raw*');
            fname = dir(pic_str);

            if isempty(fname)
                warndlg('Invalid Raw Calibration File Number in set_invFilter. Running allstop.','WARNING!!!','modal');
                errorFlag = true;
            else
                coefFileNum = RawCalibPicNum;
            end
            
            %if need an inverse calib
            if sum(strcmp('inversefilt',filttype)) || sum(strcmp('inversefilt_FPL',filttype))
                %check for missing coeff file
                p1=pwd;
                cd(NelData.File_Manager.parent_dir)
                CalibPICnum2use = findPics(sprintf('inv%d',coefFileNum));
                cd(p1);
                pic_str = sprintf('coef_%04d_%s',coefFileNum,'calib*');
                fname = dir(pic_str);
                if isempty(fname)
                    warndlg('Invalid Coefficient File Number in set_invFilter. Running allstop.','WARNING!!!','modal');
                    errorFlag = true;
                end
                
                %check for missing inv file
                pic_str = sprintf('p*inv%d*',coefFileNum);
                fname = dir(pic_str);
                
                if isempty(fname)
                    warndlg('Invalid Inverse Calib File Number in set_invFilter. Running allstop.','WARNING!!!','modal');
                    errorFlag = true;
                end
            else
                CalibPICnum2use = RawCalibPicNum;
            end
        end
    else
        CalibPICnum2use = NaN;
        coefFileNum = NaN;
    end
else
    CalibPICnum2use = NaN;
end

if errorFlag
    RawCalibPicNum = NaN;
    coefFileNum = NaN;
    CalibPICnum2use = NaN;
    filttype = {'allstop','allstop'};
end

%Inverse filter in one channel cannot be combined with allpass in the
%other. BOTH must be inversefilter, or one must be allstop

if sum(strcmp(filttype,{'inversefilt','allpass'}))== 2 || sum(strcmp(filttype,{'allpass','inversefilt'}))== 2
    warndlg('Needed to convert channel to inversefilter. Cannot pass inverse filter in one channel and allpass in the other!','WARNING!!!','modal');
    filttype = {'inversefilt','inversefilt'};
end 

%% Setting Coefficients

%channel 1
switch filttype{1}
    case 'allpass'
        %needs valid calib file
        b_chan1 = [1 zeros(1, 255)];
        fprintf('\n Channel 1 | allpass set.');
    case 'allstop'
        %doesn't need anything
        b_chan1 = zeros(1, 256);
        fprintf('\n Channel 1 | allstop set.');
    case 'inversefilt'
        %need 2 checks
        % inverse and coeffs
        coef_str = sprintf('coef_%04d_%s',coefFileNum,'calib.mat');       
        temp = load(coef_str);
        
        b_chan1 = temp.b(:)';
        fprintf('\n Channel 1 | invFIR Coefs set successfully from %s', coef_str);
    case 'inversefilt_FPL'
        %need 2 checks
        % inverse and coeffs
        coef_str = sprintf('coef_%04d_%s',coefFileNum,'calib_FPL.mat');       
        temp = load(coef_str);
        
        b_chan1 = temp.b(:)';
        fprintf('\n Channel 1 | FPL invFIR Coefs set successfully from %s', coef_str);
    otherwise
        warndlg('\n Invalid filter type specified in set_invFilter()...defaulting to allstop','WARNING!!!','modal')
        errorFlag = true;
        RawCalibPicNum = NaN;
        coefFileNum = NaN;
        b_chan1 = zeros(1, 256);
        filttype = {'allstop','allstop'};
end

%channel 2
switch filttype{2}
    case 'allpass'
        %needs valid calib file
        b_chan2 = [1 zeros(1, 255)];
        fprintf('\n Channel 2 | allpass set.');
    case 'allstop'
        %doesn't need anything
        b_chan2 = zeros(1, 256);
        fprintf('\n Channel 2 | allstop set.');
    case 'inversefilt'
        %need 2 checks
        % inverse and coeffs
        coef_str = sprintf('coef_%04d_%s',coefFileNum,'calib.mat');
        temp = load(coef_str);
        
        %sets b2 to be occupied in the case a single side calibration is done,
        %since we default to saving b first regardless of channel.
        
        if isempty(temp.b2)
            temp.b2 = temp.b;
            warning("\n \n ***Single sided calibration, but using chan 2. b2 is set to b for inverse filtering*** \n \n",[],[]);
        end
        
        b_chan2 = temp.b2(:)';
        fprintf('\n Channel 2 | invFIR Coefs set successfully from %s', coef_str);
    case 'inversefilt_FPL'
        %need 2 checks
        % inverse and coeffs
        coef_str = sprintf('coef_%04d_%s',coefFileNum,'calib_FPL.mat');
        temp = load(coef_str);
        
        %sets b2 to be occupied in the case a single side calibration is done,
        %since we default to saving b first regardless of channel.
        
        if isempty(temp.b2)
            temp.b2 = temp.b;
            warning("\n \n ***Single sided calibration, but using chan 2. b2 is set to b for inverse filtering*** \n \n",[],[]);
        end
        
        b_chan2 = temp.b2(:)';
        fprintf('\n Channel 2 | FPL invFIR Coefs set successfully from %s', coef_str);
    otherwise
        warndlg('Invalid filter type specified in set_invFilter()...defaulting to allstop','WARNING!!!','modal')
        errorFlag = true;
        RawCalibPicNum = NaN;
        coefFileNum = NaN;
        b_chan2 = zeros(1, 256);
        filttype = {'allstop','allstop'};
end


%For exporting and saving in data file
invfilterdata.CalibPICnum2use = CalibPICnum2use;
invfilterdata.filttype = filttype;
invfilterdata.coefFileNum = coefFileNum;
invfilterdata.b_chan1 = b_chan1;
invfilterdata.b_chan2 = b_chan2;
    
%temporary for debugging
%% Connecting to TDT modules
global COMM root_dir PROTOCOL
object_dir = [root_dir 'calibration\object'];

% [COMM.handle.RP2_4, status_rp2]= connect_tdt('RP2', 4);
% [COMM.handle.RX8, status_rx8]= connect_tdt('RX8', 1);
% if status_rp2 && status_rx8
%     error('How are RP2#4 and RX8 both in the circuit?');
% end
status_rx8=1;
status_rp2=0;
%Always setting something
if status_rp2
    invoke(COMM.handle.RP2_4,'LoadCof',[object_dir '\calib_invFIR_twoChan_RP2.rcx']);
    e1= COMM.handle.RP2_4.WriteTagV('FIR_Coefs1', 0, b_chan1);
    e2= COMM.handle.RP2_4.WriteTagV('FIR_Coefs2', 0, b_chan2);
    invoke(COMM.handle.RP2_4,'Run');
    fprintf('\n RP2-4 | Coefficients sucessfully loaded to TDT \n');

elseif status_rx8 % Most call for run_invCalib are from NEL1. For NEL2 (with RX8), only needed for calibrate and dpoae.
%     invoke(COMM.handle.RX8,'LoadCof',[object_dir '\calib_invFIR_twoChan_RX8.rcx']);

    %Need to load a different circuit file based on the protocol...

    switch PROTOCOL
        case 'calib'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\ABR_RX8_ADC_invCalib_2chan.rcx']);
        case 'DPOAE'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\ABR_RX8_ADC_invCalib_2chan.rcx']);
        case 'ABR'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\ABR_RX8_ADC_invCalib_2chan.rcx']);
        case 'FFR'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\FFR_RX8_ADC_invCalib_2chan.rcx']);
        case 'FFRwav'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\FFR_RX8_ADC_invCalib_2chan.rcx']);
        case 'FPL'
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\FFR_RX8_ADC_invCalib_2chan_FPL.rcx']);
        case 'EEG_BioSemi'
%             invoke(RX8,'LoadCof','C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acqusition_MP\objects\RX8_triggers.rcx');
        otherwise 
            fprintf('PROTOCOL not set in set_invFilter...setting to ABR circuit file'); 
            invoke(COMM.handle.RX8,'LoadCof',[object_dir '\ABR_RX8_ADC_invCalib_2chan.rcx']);
    end
    
    e1= RX8.WriteTagV('FIR_Coefs1', 0, b_chan1);
    e2= RX8.WriteTagV('FIR_Coefs2', 0, b_chan2);
    invoke(RX8,'Run');
    fprintf('\n RX8 | Coefficients sucessfully loaded to TDT \n');
else
    fprintf('Could not connect to RP2/RX8 or load FIR_Coefs (%s). Check zbus \n', datestr(datetime));
    e1 = false;
    e2 = false;
    invfilterdata.CalibPICnum2use = NaN;
    invfilterdata.filttype = {'ERROR','ERROR'};
    invfilterdata.coefFileNum = NaN;
end


% cd(root_dir) ;
