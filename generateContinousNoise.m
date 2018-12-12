function x = generateContinousNoise(dt,T)
    if nargin == 0
        T = 1000;
        dt = 1e-4;
    end
    %% parameters for continous noise spectrum
    % based on Baylor, Matthews, Yau. 1980 JP,309, pp. 591-621
    % the spectrum of continuous noise is approximated by the product of
    tau = 0.2;%time constant of exponential of SPR (eq.7 in Baylor et al.) 
    alpha = 1/tau;
    fc = alpha/(2*pi);%eq.21, p.610 in Baylor et al.
    gamma = alpha;
    sigma = 0.27;%SD of continuous noise (Field & Rieke, 2002)
    D = gamma*sqrt(2*sigma);%to match the amplitude - CHECK the formula!!!
    S0 = 2e-3;%Fig.4B in Burns et al. (2002)
    D = sqrt(gamma^4*S0/8);%For y
    D = S0*gamma^2/4;%For x
    Fs = 1/dt;
    T = 1000;
    t = 0:dt:T;             % Time vector
    x = zeros(1,length(t)); % Allocate output vector, set initial condition
    y = x;
    rng(1);                 % Set random seed
    for i = 1:length(t)-1
        x(i+1) = x(i)-gamma*x(i)*dt+sqrt(2*D)*sqrt(dt)*randn;
        y(i+1) = y(i)+ (-gamma*y(i) + sqrt(2*D)*x(i))*dt;
    end
    %% to-do: remove transient
    
    if nargin == 0
        [Pxx,F] = pwelch(x,[],[],[],Fs,'onesided');
        [Pyy,F] = pwelch(y,[],[],[],Fs,'onesided');
        Pth = 4*D./(gamma^2 + (2*pi*F).^2);%See p.14 of Lindner
        Pth_y = 2*Pth.^2;
        
        close all;
        ft_sz = 20;
        figure;
        subplot(1,2,1)
        plot(t,x);
        hold on
        plot(t,y);
        set(gca,'xlim',[50 100],'fontsize',ft_sz)
        xlabel('Time (sec)');ylabel('A.U.')
        subplot(1,2,2)
        h_Pxx = loglog(F,Pxx);
        hold on
        h_Pyy = loglog(F,Pyy);
        h_Pth = loglog(F,Pth);
        h_Pth_y = loglog(F,Pth_y);
        set([h_Pxx h_Pth],'linewidth',2)
        set(gca,'xlim',[0.01 10],'fontsize',ft_sz)
        xlabel('Freq (Hz)'); ylabel('PSD');
        legend({'Simulated','Lorentzian'})
    end
    
end