clc;
clearvars;

MCMC2=false;
commSP=false;
intXs=false;

% pipeine directory
wdpath=fullfile('...','bakeoff','pipeline');

% run settings
bakeoffSettings=fullfile(wdpath,'SCRIPTS','settingsHMSCmatlab.m');
bakeoff_ssSettings=fullfile(wdpath,'SCRIPTS','settings_ssHMSCmatlab.m');
run(bakeoffSettings)

for dsz = [1 3];
    for s = [1:5];

        run(bakeoffSettings)
        run(fullfile(wdpath,'MODELS','fit_predict_hmsc.m'))    

        run(bakeoffSettings)
        run(fullfile(wdpath,'MODELS','fit_predict_hmsc_ss.m'))

    end
end



 

