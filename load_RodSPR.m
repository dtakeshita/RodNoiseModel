function out = load_RodSPR(  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    dat_path = './RodData';
    fn_fit = 'WT_fit.txt';
    fn = 'WT.txt';
    dat_rod =  load(fullfile(dat_path, fn_fit));
    dat_rod_raw = load(fullfile(dat_path, fn));
    out.t = dat_rod(:,1)';
    out.I = dat_rod(:,2)';
    rawT = dat_rod_raw(:,1)';
    
    out.rawI = dat_rod_raw(rawT>=0,2)';
    out.rawT = dat_rod_raw(rawT>=0,1)';
    dt = mean(diff(out.t));
    out.fs = 1/dt;

end

