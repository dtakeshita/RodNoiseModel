close all; clear all;
dat_path = '/Users/dtakeshi/Documents/MATLAB/RodNoiseModel/RodData';
fn_wt = 'WT.txt';
fn_fit = 'WT_fit.txt';

%opn_dat = load(fullfile(dat_path, fn_opn));
wt_dat =  load(fullfile(dat_path, fn_wt));
t0 = wt_dat(:,1);%in sec
I = wt_dat(:,2);%in pA
t = t0(t0>0);
I = I(t0>0);

%err = @(y,yhat)norm(y

f = fittype('a*x^c.*exp(-x/b)');
[fit1, gof, fitinfo] = fit(t,I,f,'Startpoint',[1.2 0.2 1]);
Ifit = fit1(t);
dat = [t Ifit];
save(fullfile(dat_path,fn_fit), 'dat', '-ascii')

plot(t,Ifit,'r-',t,I)

