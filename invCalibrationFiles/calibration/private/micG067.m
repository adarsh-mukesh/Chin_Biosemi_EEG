function mic = micG067;
% Calibration file for microphone/probe 'G067'.
% dBV = absolute mic calib = dB re 1V from B&K amp with 0 dB B&K gain
%      and an input signal of 124 dB SPL at 250 Hz (e.g. from pistonphone).
% CalData column 1 is frequency in kHz.
%         column 2 is gain calib, so dBSPL=dBre1V-dBV+column2.
%			    (to get the probe correction, subtract 124 dB.)
%         column 3 is phase correction, phase = phase from lockin + column 3.
%			    (note, no unwrapping has been done.)

mic = struct('number', 390067, 'probename', 'G067', ...
      'MicDate', '06-Aug-2002 ', ...
      'preamp', 0, 'S0', 0, 'expect', 0, ...
      'dBV', -8.2528, ...
      'CalData', {[
        0.04, 124.862, -1.96299;
        0.0428709, 124.611, -1.97515;
        0.0459479, 124.531, -1.97585;
        0.0492458, 124.466, -1.97678;
        0.0527803, 124.466, -1.97725;
        0.0565685, 124.435, 0.0298522;
        0.0606287, 124.451, 0.0277889;
        0.0649802, 124.483, 0.0250269;
        0.069644, 124.464, 0.0278013;
        0.0746426, 124.496, 0.0295625;
        0.08, 124.51, 0.031762;
        0.0857419, 124.538, 0.031887;
        0.0918959, 124.531, 0.0338825;
        0.0984916, 124.557, 0.0353275;
        0.105561, 124.56, 0.0353916;
        0.113137, 124.572, 0.0379547;
        0.121257, 124.565, 0.0390437;
        0.12996, 124.569, 0.0431067;
        0.139288, 124.582, 0.0439293;
        0.149285, 124.597, 0.0455129;
        0.16, 124.593, 0.0478564;
        0.171484, 124.606, 0.0524706;
        0.183792, 124.6, 0.0542367;
        0.196983, 124.611, 0.0572917;
        0.211121, 124.596, 0.0615742;
        0.226274, 124.591, 0.0650312;
        0.242515, 124.595, 0.0695706;
        0.259921, 124.593, 0.0738263;
        0.278576, 124.598, 0.07834;
        0.298571, 124.609, 0.0847213;
        0.32, 124.612, 0.0889539;
        0.342968, 124.626, 0.0976151;
        0.367583, 124.626, 0.102957;
        0.393966, 124.633, 0.107104;
        0.422243, 124.668, 0.11833;
        0.452548, 124.741, 0.126535;
        0.485029, 124.822, 0.139282;
        0.519842, 125.006, 0.153699;
        0.557152, 124.713, 0.148868;
        0.597141, 124.345, 0.131654;
        0.64, 124.438, 0.18283;
        0.685935, 124.533, 0.196803;
        0.735167, 124.785, 0.20771;
        0.787932, 124.65, 0.223404;
        0.844485, 124.712, 0.237137;
        0.905097, 124.726, 0.254109;
        0.970059, 124.841, 0.265921;
        1.03968, 124.786, 0.288879;
        1.1143, 124.868, 0.312627;
        1.19428, 124.988, 0.337849;
        1.28, 125.102, 0.363316;
        1.37187, 125.164, 0.390783;
        1.47033, 125.317, 0.42757;
        1.57586, 125.518, 0.455904;
        1.68897, 125.723, 0.48977;
        1.81019, 126.02, 0.523372;
        1.94012, 126.363, -1.44109;
        2.07937, 126.852, -1.40179;
        2.22861, 127.435, -1.36492;
        2.38856, 128.062, -1.32496;
        2.56, 128.626, -1.28318;
        2.74374, 129.29, 0.755834;
        2.94067, 129.98, 0.788436;
        3.15173, 130.57, 0.829426;
        3.37794, 131.57, 0.873609;
        3.62039, 132.227, 0.9183;
        3.88023, 133.053, 0.957898;
        4.15873, 133.734, -1.00347;
        4.45722, 134.512, -0.959797;
        4.77713, 134.962, -0.920072;
        5.12, 135.911, -0.873225;
        5.48748, 136.674, 1.16837;
        5.88134, 137.157, 1.2138;
        6.30346, 137.86, 1.28598;
        6.75588, 138.45, -0.663596;
        7.24077, 139.07, -0.597192;
        7.76047, 139.583, -0.528846;
        8.31746, 140.517, -0.458033;
        8.91444, 141.022, -0.378479;
        9.55426, 141.753, -0.294485;
        10.24, 142.425, -0.212009;
        10.975, 143.196, 1.88203;
        11.7627, 143.596, -0.0222061;
        12.6069, 143.636, 0.0892937;
        13.5118, 143.807, 0.228536;
        14.4815, 144.659, 0.396679;
        15.5209, 146.425, 0.567343;
        16.6349, 148.424, 0.710747;
        17.8289, 150.097, 0.831512;
        19.1085, 151.335, 0.940144;
        20.48, 150.45, 1.04531;
        21.9499, 148.198, -0.690353;
        23.5253, 149.489, -0.32105;
        25.2138, 154.028, -0.0516968;
        27.0235, 157.125, 0.170562;
        28.9631, 159.916, -1.57216;
        31.0419, 162.682, 0.716729;
        33.2699, 168.816, -0.880862;
        35.6578, 182.573, -0.688743;
        38.217, 204, -0.338842;
        40.96, 204, -0.338842;
       ]});