function [stim_vec,triglist,ntrials]=stim_import(stim_id)

switch stim_id
    case 'STM_ACC'
        stim_vec=cell(2,1);
        dr_str='C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\stims\';
        list={'1','2'};
        co=listdlg('PromptString',{'Select cylces/octave'},'SelectionMode','single','ListString',list);
        ntrials = 600;
        str1=strcat(dr_str,'stim_noise1_up1_',num2str(co),'co.mat');
        str2=strcat(dr_str,'stim_down1_up1_',num2str(co),'co.mat');
        load(str1);
        load(str2);
        x_nu = stim_noise5_up5_2co;
        x_du = stim_down5_up5_2co;
        
        
        x_nu = scaleSound(x_nu);
        x_du = scaleSound(x_du);
        
        triglist=[];
        for ii=1:ntrials/10
            triglist=[triglist;randi([1 2],10,1)];
        end
        stim_vec{1,1}=x_nu;
        stim_vec{2,1}=x_du;
    
    case 'GDT_human'
        stim_vec=cell(3,1);
        ntrials = 200;
        load('C:\Users\Heinz Lab - NEL2\Desktop\Andrew_EEG\ACC_HeinzLab\Acquisition_MP\stims\gdt_chum_all.mat');
        x_16 = scaleSound(x_16);
        x_32 = scaleSound(x_32);
        x_64 = scaleSound(x_64);
        stim_vec{1,1}=x_16;
        stim_vec{2,1}=x_32;
        stim_vec{3,1}=x_64;
        
        triglist = repmat([1;2;3],ntrials,1);
end
end
        
        

       
        
   