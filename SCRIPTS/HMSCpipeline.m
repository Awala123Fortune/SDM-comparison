clc;
clearvars;

MCMC2 = false;
commSP = false;
intXs = false;

% pipeine directory
wdpath = fullfile('...','bakeoff','pipeline');

% run settings
bakeoffSettings = fullfile(wdpath,'SCRIPTS','settingsHMSCmatlab.m');
bakeoff_ssSettings = fullfile(wdpath,'SCRIPTS','settings_ssHMSCmatlab.m');
run(bakeoffSettings)

dsz = 1     % data size (1 or 3)
s = 1       % data set (1-5)

run(bakeoffSettings)
run(fullfile(wdpath,'MODELS','fit_predict_hmsc.m'))    
run(bakeoff_ssSettings)
run(fullfile(wdpath,'MODELS','fit_predict_hmsc_ss.m'))
