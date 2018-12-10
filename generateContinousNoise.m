function generateContinousNoise
    k1 = 3.8e-4;%s^-1
    k2 = 1.8;%s^-1
    ahat = 1.6e-5;%s^-1
    PD = 0.1;%Rieke & Baylor, but check this
    
    gamma = k2;
    D = k2*PD*ahat;

%     gamma = 20;
%     mu = 0;
%     D = 0.3;
    dt = 1e-3;
    Fs = 1/dt;
    T = 1000;
    t = 0:dt:T;             % Time vector
    x = zeros(1,length(t)); % Allocate output vector, set initial condition
    rng(1);                 % Set random seed
    for i = 1:length(t)-1
        x(i+1) = x(i)-gamma*x(i)*dt+sqrt(2*D)*sqrt(dt)*randn;
    end
    [Pxx,F] = pwelch(x,[],[],[],Fs,'twosided');
    Pth = 2*D./(gamma^2 + (2*pi*F).^2);%See p.14 of Lindner
    close all;
    ft_sz = 20;
    figure;
    subplot(1,2,1)
    plot(t,x);
    set(gca,'xlim',[50 100],'fontsize',ft_sz)
    xlabel('Time (sec)');ylabel('A.U.')
    subplot(1,2,2)
    h_Pxx = loglog(F,Pxx);
    hold on
    h_Pth = loglog(F,Pth);
    set([h_Pxx h_Pth],'linewidth',2)
    set(gca,'xlim',[0.01 10],'fontsize',ft_sz)
    xlabel('Freq (Hz)'); ylabel('PSD');
    legend({'Simulated','Lorentzian'})

    
end