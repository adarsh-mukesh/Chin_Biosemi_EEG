d1=pwd;
calib_dir='C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\invCalibrationFiles\calibration';
cd(calib_dir);
global NelData 
calibrate_noNEL;

NelData.File_Manager.parent_dir='C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP';
foldername = NelData.File_Manager.dirname ;
cd(foldername)
d2=dir('*inv*');
calibFname=d2(1,1).name;
d2=dir('coef*');
coefFname=d2(1,1).name;

eval([sprintf('a1=%s',calibFname(1:end-2))]);
% 
calibdata=a1.CalibData;
cd(d1)
% do dir and max to get latest inv calib file - use that one.
% invCalibpic = dir('*inv*.m')

% Pick calib file to use - MUST be INV calib
% INVcalPICnum = 2;
%  calibFname=sprintf('p%04d_calib_inv%d',INVcalPICnum,INVcalPICnum-1);
% % coefFname= sprintf('coef_%04d_%s',INVcalPICnum-1,'calib.mat');       

% 
% Chin_Biosemi_EEG
% 
% 
% 
% % set to all-pass
% fname = current_data_file('calib',1);  % MH/GE 11/03/03 added suppress_unitno flag to generalize
%         
%         if newCalib
%             fname= strcat(fname, '_raw');
%         else
%             fname= sprintf('%s_inv%d', fname, coefFileNum);
%         end
% 
% 

