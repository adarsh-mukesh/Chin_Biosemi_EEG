function x = makeACCStim(F0_A,F0_B,ncycles_A, ncycles_B, fs)
%ABA Paradigm, with respective durations.
%concatenated using nearest zero-crossing to the proposed duration
%Therefore, need to specify in terms of cycles instead of s.

%all harmonics in sin phase, can tweak these params later/pass them thru if
%necessary
db_main = 55;
db_flank = 49;
rank = 1;
nharms = 4; %add two harmonics that flank
ramp = .010; %10 ms ramp applied to whole stimulus

dur_A = ncycles_A*1/F0_A;
dur_B = ncycles_B*1/F0_B;

a = makeComplexTone_noRamp(F0_A, dur_A,fs,db_main,db_flank,rank,nharms);
b = makeComplexTone_noRamp(F0_B, dur_B,fs,db_main,db_flank,rank,nharms);

x = rampsound([a,b,a],fs,ramp);

end

