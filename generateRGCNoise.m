clear; close;
r_set = 50;
%spr = load_RodSPR();
spr = load_RGCdimFlash();% need to scale
fs = 10000;
dt = 1/fs;
Tsim = 1000;%simulated time in sec
%% generate pigment noise
p = generate_pigmentnoise( spr.I, r_set, spr.fs, Tsim, 1 );
t = p.Process.data{1}.xvalue;
dat = p.Process.data{1}.value;
%% generate continous noise
cont = generateContinousNoise(dt,Tsim);
%out = dat+cont;
plot(dt*[1:length(dat)],dat)