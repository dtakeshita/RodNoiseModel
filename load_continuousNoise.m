function C = load_continuousNoise()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fn = fullfile('.','RodData','BurnsContinuousNoise.mat');
    C = load(fn);
end

