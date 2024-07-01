function mic = mic168;
% Calibration file for microphone/probe '168'.
% dBV = absolute mic calib = dB re 1V from B&K amp with 0 dB B&K gain
%      and an input signal of 124 dB SPL at 250 Hz (e.g. from pistonphone).
% CalData column 1 is frequency in kHz.
%         column 2 is gain calib, so dBSPL=dBre1V-dBV+column2.
%			    (to get the probe correction, subtract 124 dB.)
%         column 3 is phase correction, phase = phase from lockin + column 3.
%			    (note, no unwrapping has been done.)

mic = struct('number', 2308168, 'probename', '168', ...
      'date', '01-Oct-2001', ...
      'preamp', 0, 'S0', 0, 'expect', 0, ...
      'dBV', -7.56402, ...
      'CalData', {[
           0.00100,  128.63600,    0.00000;
           0.00106,  128.39200,    0.00000;
           0.00112,  128.13700,    0.00000;
           0.00119,  127.87000,    0.00000;
           0.00126,  127.59500,    0.00000;
           0.00133,  127.32500,    0.00000;
           0.00141,  127.06800,    0.00000;
           0.00150,  126.83300,    0.00000;
           0.00158,  126.61200,    0.00000;
           0.00168,  126.40200,    0.00000;
           0.00178,  126.20000,    0.00000;
           0.00188,  126.00900,    0.00000;
           0.00200,  125.83200,    0.00000;
           0.00211,  125.67100,    0.00000;
           0.00224,  125.52400,    0.00000;
           0.00237,  125.39100,    0.00000;
           0.00251,  125.26500,    0.00000;
           0.00266,  125.15100,    0.00000;
           0.00282,  125.04900,    0.00000;
           0.00299,  124.95600,    0.00000;
           0.00316,  124.86600,    0.00000;
           0.00335,  124.78100,    0.00000;
           0.00355,  124.70200,    0.00000;
           0.00376,  124.63100,    0.00000;
           0.00398,  124.56600,    0.00000;
           0.00422,  124.51100,    0.00000;
           0.00447,  124.46700,    0.00000;
           0.00473,  124.43100,    0.00000;
           0.00501,  124.39800,    0.00000;
           0.00531,  124.36100,    0.00000;
           0.00562,  124.32800,    0.00000;
           0.00596,  124.29600,    0.00000;
           0.00631,  124.27100,    0.00000;
           0.00668,  124.24600,    0.00000;
           0.00708,  124.22000,    0.00000;
           0.00750,  124.19500,    0.00000;
           0.00794,  124.17400,    0.00000;
           0.00841,  124.16000,    0.00000;
           0.00891,  124.14600,    0.00000;
           0.00944,  124.13100,    0.00000;
           0.01000,  124.11600,    0.00000;
           0.01059,  124.10300,    0.00000;
           0.01122,  124.09600,    0.00000;
           0.01189,  124.08300,    0.00000;
           0.01259,  124.07000,    0.00000;
           0.01334,  124.05600,    0.00000;
           0.01413,  124.05500,    0.00000;
           0.01496,  124.05200,    0.00000;
           0.01585,  124.04500,    0.00000;
           0.01679,  124.03300,    0.00000;
           0.01778,  124.02500,    0.00000;
           0.01884,  124.02400,    0.00000;
           0.01995,  124.02200,    0.00000;
           0.02113,  124.02100,    0.00000;
           0.02239,  124.01600,    0.00000;
           0.02371,  124.01400,    0.00000;
           0.02512,  124.01000,    0.00000;
           0.02661,  124.00700,    0.00000;
           0.02818,  124.00400,    0.00000;
           0.02985,  124.00100,    0.00000;
           0.03162,  123.99800,    0.00000;
           0.03350,  123.99500,    0.00000;
           0.03548,  123.99300,    0.00000;
           0.03758,  123.99200,    0.00000;
           0.03981,  123.99000,    0.00000;
           0.04217,  123.98700,    0.00000;
           0.04467,  123.98400,    0.00000;
           0.04732,  123.98200,    0.00000;
           0.05012,  123.98100,    0.00000;
           0.05309,  123.98300,    0.00000;
           0.05623,  123.98400,    0.00000;
           0.05957,  123.98400,    0.00000;
           0.06310,  123.98400,    0.00000;
           0.06683,  123.98400,    0.00000;
           0.07079,  123.98400,    0.00000;
           0.07499,  123.98400,    0.00000;
           0.07943,  123.98500,    0.00000;
           0.08414,  123.98600,    0.00000;
           0.08913,  123.98700,    0.00000;
           0.09441,  123.98900,    0.00000;
           0.10000,  123.99000,    0.00000;
           0.10592,  123.99300,    0.00000;
           0.11220,  123.99300,    0.00000;
           0.11885,  123.99300,    0.00000;
           0.12589,  123.99400,    0.00000;
           0.13335,  123.99400,    0.00000;
           0.14125,  123.99400,    0.00000;
           0.14962,  123.99400,    0.00000;
           0.15849,  123.99500,    0.00000;
           0.16788,  123.99600,    0.00000;
           0.17783,  123.99700,    0.00000;
           0.18837,  123.99900,    0.00000;
           0.19953,  123.99600,    0.00000;
           0.21135,  123.99500,    0.00000;
           0.22387,  123.99700,    0.00000;
           0.23714,  124.00000,    0.00000;
           0.25119,  124.00500,    0.00000;
           0.26607,  124.00700,    0.00000;
           0.28184,  124.01000,    0.00000;
           0.29854,  124.00800,    0.00000;
           0.31623,  124.00800,    0.00000;
           0.33496,  124.00700,    0.00000;
           0.35481,  124.01000,    0.00000;
           0.37584,  124.01200,    0.00000;
           0.39811,  124.01500,    0.00000;
           0.42170,  124.01800,    0.00000;
           0.44668,  124.01900,    0.00000;
           0.47315,  124.01600,    0.00000;
           0.50119,  124.01600,    0.00000;
           0.53088,  124.01200,    0.00000;
           0.56234,  124.01100,    0.00000;
           0.59566,  124.01200,    0.00000;
           0.63096,  124.01000,    0.00000;
           0.66834,  124.00700,    0.00000;
           0.70795,  124.00400,    0.00000;
           0.74989,  124.00400,    0.00000;
           0.79433,  124.00400,    0.00000;
           0.84140,  124.00200,    0.00000;
           0.89125,  123.99900,    0.00000;
           0.94406,  123.99800,    0.00000;
           1.00000,  123.99700,    0.00000;
           1.05925,  123.99600,    0.00000;
           1.12202,  123.99300,    0.00000;
           1.18850,  123.99200,    0.00000;
           1.25893,  123.99000,    0.00000;
           1.33352,  123.99000,    0.00000;
           1.41254,  123.99100,    0.00000;
           1.49624,  123.99100,    0.00000;
           1.58489,  123.99100,    0.00000;
           1.67880,  123.98600,    0.00000;
           1.77828,  123.98700,    0.00000;
           1.88365,  123.98800,    0.00000;
           1.99526,  123.99200,    0.00000;
           2.11349,  123.99400,    0.00000;
           2.23872,  123.99700,    0.00000;
           2.37137,  123.99900,    0.00000;
           2.51189,  123.99700,    0.00000;
           2.66073,  124.00000,    0.00000;
           2.81838,  124.00400,    0.00000;
           2.98538,  124.00400,    0.00000;
           3.16228,  124.00500,    0.00000;
           3.34965,  124.00500,    0.00000;
           3.54813,  124.00200,    0.00000;
           3.75837,  124.00100,    0.00000;
           3.98107,  124.00000,    0.00000;
           4.21697,  123.99500,    0.00000;
           4.46684,  123.99200,    0.00000;
           4.73151,  123.99300,    0.00000;
           5.01187,  123.98600,    0.00000;
           5.30884,  124.00000,    0.00000;
           5.62341,  123.99800,    0.00000;
           5.95662,  123.97700,    0.00000;
           6.30957,  123.98200,    0.00000;
           6.68344,  123.96100,    0.00000;
           7.07946,  123.95400,    0.00000;
           7.49894,  123.93400,    0.00000;
           7.94328,  123.87900,    0.00000;
           8.41395,  123.85900,    0.00000;
           8.91251,  123.84400,    0.00000;
           9.44061,  123.85600,    0.00000;
          10.00000,  123.82100,    0.00000;
          10.59250,  123.76200,    0.00000;
          11.22020,  123.72300,    0.00000;
          11.88500,  123.64600,    0.00000;
          12.58930,  123.52400,    0.00000;
          13.33520,  123.52400,    0.00000;
          14.12540,  123.57500,    0.00000;
          14.96240,  123.59800,    0.00000;
          15.84890,  123.64000,    0.00000;
          16.78800,  123.53100,    0.00000;
          17.78280,  123.53500,    0.00000;
          18.83650,  123.58700,    0.00000;
          19.95260,  123.61700,    0.00000;
          21.13490,  123.64900,    0.00000;
          22.38720,  123.73000,    0.00000;
          23.71370,  123.76000,    0.00000;
          25.11890,  123.81200,    0.00000;
          26.60730,  123.91000,    0.00000;
          28.18380,  123.79000,    0.00000;
          29.85380,  123.78700,    0.00000;
          31.62280,  123.65800,    0.00000;
          33.49650,  123.78500,    0.00000;
          35.48130,  123.92400,    0.00000;
          37.58370,  124.12900,    0.00000;
          39.81068,  124.12900,    0.00000;
          42.16961,  124.12900,    0.00000;
       ]});