function [P, factor] = scalePS(Pref, P, Frange, varargin)
% scale powerspectrum
    if nargin >=4
        PSref_field = varargin{1};
    else
        PSref_field = {'xvalue','value'};
    end
    if nargin >= 5
        P_field = varargin{2};
    else
        P_field = {'freq','Pxx'};
    end
    
    PSDref.xvalue = ref_struct(Pref,PSref_field{1});
    PSDref.value = ref_struct(Pref,PSref_field{2});
    P.freq = ref_struct(P,P_field{1});
    P.Pxx = ref_struct(P,P_field{2});
    PSDref_val = mean_with_range(PSDref.value, PSDref.xvalue, Frange);
    PSD_val = mean_with_range(P.Pxx, P.freq, Frange);
    factor = PSDref_val/PSD_val;
    P.Pxx = P.Pxx * factor;
end

function out = mean_with_range(Y,X,Xrange)
    idx = Xrange(1) < X & X < Xrange(2);
    dat_used = Y(idx);
    dat_used = dat_used(~isnan(dat_used));
    out = nanmean(dat_used);
end