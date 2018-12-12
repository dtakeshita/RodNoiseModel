close all; clear all;
dat_path = './RGCData';
fn_rgc = 'RGCdimFlashResponse_022018Ac2.mat';
fn_fit = 'RGCfitSpline_022018Ac2.txt';

%opn_dat = load(fullfile(dat_path, fn_opn));
rgc =  load(fullfile(dat_path, fn_rgc));
% t0 = wt_dat(:,1);%in sec
% I = wt_dat(:,2);%in pA
t0 = rgc.t'
dt = mean(diff(t0));
I = -rgc.I';
t1 = t0(t0>0);
t2 = dt*[0:length(t1)-1]';
I = I(t0>0);
I = I/max(I)

%err = @(y,yhat)norm(y

f = fittype('a*x^c.*exp(-x.^d/b)');
%[fit1, gof, fitinfo] = fit(t2,I,f,'Startpoint',[10 0.2 0.5 1]);
fit1 = fit(t2,I,'smoothingspline','SmoothingParam',0.999);
Ifit = fit1(t2);
plot(t2,Ifit,'r-',t2,I)

dat = [t2 Ifit I];
save(fullfile(dat_path,fn_fit), 'dat', '-ascii')



