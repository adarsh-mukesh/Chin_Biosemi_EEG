function [x, sigrms_out] = makeACCStim_swept(F0_A,F0_B,dur_A, dur_B, alt, noise_on, db_flank, db_main, sigrms, rank, nharms, ramp, t_transit, fs)
%AB Paradigm, with respective durations.
%swept up with transition time t_transit.

harmonics = (rank-1):(rank+nharms); %so 8 total in this case

t_len = floor(dur_A*fs)+floor(t_transit*fs)+floor(dur_B*fs);
t = (0:t_len-1)/fs;

x = zeros(1,length(t));
for k = 1:length(harmonics)
    f_a = harmonics(k)*F0_A;
    f_b = harmonics(k)*F0_B;

    %phase calculations:
    slope = (f_b-f_a)/t_transit;
    phi1 = zeros(1,floor(dur_A*fs));
    phi2 = pi*slope*t(1:floor(t_transit*fs)).^2;
    phi3 = 2*(f_b-f_a)*pi.*t(1:floor(dur_B*fs))+phi2(end);

    %piece-wise phase transition results in F0_A -> sweep -> F0_B
    phi = [phi1,phi2,phi3];
    
    %set phase to alternating, shift to start at zero
    if alt == 1
        phi = phi + mod(k,2)*pi/2 + pi/4;
    elseif alt == 0
        phi = phi + pi/2;
    end
    
    if(k==1 || k==length(harmonics))
        mag = db2mag(db_flank); 
    else
        mag = db2mag(db_main);
    end
    
    x = x + mag*cos(2*pi*F0_A*harmonics(k)*t + phi);

end
sig_dB_overall = log10(nharms*10^(db_main/10) + 2*10^(db_flank/10))*10;
x = x / rms(x) * sigrms;
sigrms_out = rms(x);

short_ramp = 0.01;
x = rampsound(x,fs,short_ramp);

if noise_on
    db_noise_lf = -30; %second band of noise to mask DPs, set at 30 dB below tone complex
    dur = dur_A + dur_B;
    
    f_low = 20;
    f_high_lf = harmonics(1)*F0_A*2^(-1/2); %for dp masking noise, low pass below half octave below nominal freq.
    buff = 0.03;
    tmax = dur + buff;
    x = [zeros(1,floor(fs*buff)),x];
    noise = rand(length(x),1)-.5; %uniformly distributed;
    noise = noise/rms(noise)*sigrms;

    rms_noise = sigrms*db2mag(db_noise_lf);

    %limiting cutoff to a max of 500 Hz
    if f_high_lf>=500
        f_high_lf = 500;
    end
    [b,a] = butter(4,f_high_lf/(fs/2),'low');
    dp_noise = filtfilt(b,a,noise);
    dp_noise = dp_noise/rms(dp_noise) * rms_noise;

    x = x + dp_noise';
    
end

x = rampsound(x,fs,ramp);

end

