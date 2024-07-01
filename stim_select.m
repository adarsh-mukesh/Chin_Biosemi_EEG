%%% this code selects the stimuli that you want to play
 list={'2 STM ACC','GDT stim 4T3G'};
 stim_ord=listdlg('PromptString',{'Select stim'},'SelectionMode','single','ListString',list);
 switch stim_ord
     case 1
         [stim_vec,triglist]=stim_import('STM_ACC');
     case 2
         [stim_vec,triglist]=stim_import('GDT_human');
 end