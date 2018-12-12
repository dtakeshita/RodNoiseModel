close;clear;
rgc = load_RGCdimFlash( );
rod = load_RodSPR();
Fs = 10000;
% Irod = rod.I;
% Irgc = rgc.I;
Irod = rod.rawI;
Irgc = rgc.rawI;
L = length(Irod);
NFFT = 2^nextpow2(L);
f_rod = fft(Irod, NFFT);
f_rgc = fft(Irgc,NFFT);
freq = Fs/2*linspace(0,1,NFFT/2+1);
f_freq = f_rgc./f_rod;%filter in frequency domain
f_time = ifft(f_freq);

rgc_prd = ifft(fft(Irod).*fft(f_time,length(Irod)));

figure;
subplot(2,2,1)
plot(rod.t, rod.rawI)
title('Rod SPR');
xlabel('Time (sec)');
ylabel('I (pA)')
subplot(2,2,2)
plot(rgc.t, rgc.rawI)
title('RGC response');
xlabel('Time (sec)');
ylabel('Response (a.u.)')
subplot(2,2,3)
loglog(freq, abs(f_freq(1:NFFT/2+1)))
title('Retinal filter');
xlabel('Frequency (Hz)');
ylabel('"Gain"');

%% filter (simulated) continuous noise
C = load_continuousNoise();
cont_noise = C.x;
cont_noise_filtered = ifft(fft(cont_noise).*fft(f_time,length(cont_noise)));
[Pxx_cont,Fcont] = pwelch(cont_noise,[],[],[],Fs,'onesided');
[Pxx_cont_f,Fcont_f] = pwelch(cont_noise_filtered,[],[],[],Fs,'onesided');
Pc.freq = Fcont;
Pc.Pxx = Pxx_cont;
Pc_f.freq = Fcont_f;
Pc_f.Pxx = Pxx_cont_f;
[Psc, factor] = scalePS(Pc, Pc_f, [1e-3 0.05], {'freq','Pxx'},{'freq','Pxx'});


subplot(2,2,4)
h_Pc=loglog(Fcont, Pxx_cont,'b');
hold on
h_Pc_f = loglog(Psc.freq, Psc.Pxx,'r');
xlabel('Frequency (Hz)');
ylabel('PSD');
legend([h_Pc h_Pc_f], {'(simulated) continuous noise','cont. noise fileterd by the retinal fitler (scaled)'})

ah = findobj(gcf,'type','axes');


