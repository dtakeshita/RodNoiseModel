function out = load_RGCdimFlash(  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    dat_path = './RGCData';
    fn_fit = 'RGCfitSpline_022018Ac2.txt';
    dat_rod =  load(fullfile(dat_path, fn_fit));
    out.t = dat_rod(:,1)';
    out.I = dat_rod(:,2)';
    out.rawI = dat_rod(:,3)';
    dt = mean(diff(out.t));
    out.fs = 1/dt;

end

