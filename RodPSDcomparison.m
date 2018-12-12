% compare PSD from cotinuous noise and SPR
clear; close all;

%% continuous noise
C = load_continuousNoise();
Fs = 10000;%better to check
[Pxx_cont,Fcont] = pwelch(C.x,[],[],[],Fs,'onesided');
Pc.freq = Fcont;
Pc.Pxx = Pxx_cont;
%% rod single photon response
spr = load_RodSPR;
Fs = spr.fs;
dt = 1/Fs;
sig = spr.rawI;
L = length(sig);
NFFT = 2^nextpow2(L);
Y = fft(sig,NFFT);
f = Fs/2*linspace(0,1,NFFT/2+1);
Pxx = abs(Y).^2/L*dt;
Pspr.freq = f;
Pspr.Pxx = Pxx;
[Psc, factor] = scalePS(Pc, Pspr, [0.2 0.8], {'freq','Pxx'},{'freq','Pxx'});

figure;
%loglog(f,Pxx(1:NFFT/2+1));
loglog(f,Psc.Pxx(1:NFFT/2+1),'color','b','linewidth',2);
hold on
loglog(Fcont,Pxx_cont,'color','r','linewidth',2);
set(gca,'xlim',[0.1 100],'ylim',[1e-8 1e-2],'fontsize',18,'box','off')
