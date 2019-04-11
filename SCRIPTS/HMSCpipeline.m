
clc;
clearvars;


job_HMSCbird = batch('jobHMSCbirds');
job_HMSCbutterfly_dsz3 = batch('jobHMSCbutter_dsz3');
job_HMSCplant_dsz3 = batch('jobHMSCplant_dsz3');
job_HMSCtree_dsz3 = batch('jobHMSCtree_dsz3');
job_HMSCveg_dsz3 = batch('jobHMSCveg_dsz3');

% job_HMSCbird_dsz3 = batch('jobHMSCbirds_dsz3');
% job_HMSCbutterfly_dsz3 = batch('jobHMSCbutter_dsz3');
% job_HMSCplant_dsz3 = batch('jobHMSCplant_dsz3');
% job_HMSCtree_dsz3 = batch('jobHMSCtree_dsz3');
% job_HMSCveg_dsz3 = batch('jobHMSCveg_dsz3');

%job_ssHMSCveg_dsz3 = batch('job_ssHMSCveg_dsz3');
%job_ssHMSCveg_dsz3_2 = batch('job_ssHMSCveg_dsz3_2');

%job_ssHMSCbird_dsz3 = batch('job_ssHMSCbirds_dsz3');
%job_ssHMSCplant_dsz3 = batch('job_ssHMSCplant_dsz3');

%job_ssHMSCbutterfly_dsz3 = batch('job_ssHMSCbutter_dsz3');
%job_ssHMSCtree_dsz3 = batch('job_ssHMSCtree_dsz3');

%job_ssHMSCbird = batch('job_ssHMSCbirds');
%job_ssHMSCplant = batch('job_ssHMSCplant');

%job_ssHMSCveg = batch('job_ssHMSCveg');

%job_ssHMSCbutterfly = batch('job_ssHMSCbutter');
%job_ssHMSCtree = batch('job_ssHMSCtree');

% job_HMSCbird_dsz3 = batch('jobHMSCbirds_dsz3');
% job_HMSCbutterfly_dsz3 = batch('jobHMSCbutter_dsz3');
% job_HMSCplant_dsz3 = batch('jobHMSCplant_dsz3');
% job_HMSCtree_dsz3 = batch('jobHMSCtree_dsz3');
% job_HMSCveg_dsz3 = batch('jobHMSCveg_dsz3');


MCMC2=false;
commSP=true;
intXs=false;

% pipeine directory
%wdpath=fullfile('...','bakeoff','pipeline');
%wdpath=fullfile('/Users/anorberg/OneDrive - University of Helsinki/','bakeoff','pipeline');
wdpath=fullfile('D:\HY-data\NORBERG\OneDrive - University of Helsinki\','bakeoff','pipeline');
fpath=fullfile('F:\FITS');

% run settings
bakeoffSettings=fullfile(wdpath,'SCRIPTS','settingsHMSCmatlab.m');
bakeoff_ssSettings=fullfile(wdpath,'SCRIPTS','settings_ssHMSCmatlab.m');
run(bakeoffSettings)

dsz=1     % data size (1, 2 or 3)
s=1       % data set

        %run(bakeoffSettings)
        %run(fullfile(wdpath,'MODELS','fit_predict_hmsc.m'))    
        %run(fullfile(wdpath,'MODELS','predict_hmsc.m'))    

        run(bakeoffSettings)
        run(fullfile(wdpath,'MODELS','fit_predict_hmsc_ss.m'))



 

