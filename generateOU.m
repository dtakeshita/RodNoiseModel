function generateOU
    gamma = 20;
    mu = 0;
    D = 0.3;
    dt = 1e-3;
    Fs = 1/dt;
    T = 1000;
    t = 0:dt:T;             % Time vector
    x = zeros(1,length(t)); % Allocate output vector, set initial condition
    rng(1);                 % Set random seed
    for i = 1:length(t)-1
        x(i+1) = x(i)+gamma*(mu-x(i))*dt+sqrt(2*D)*sqrt(dt)*randn;
    end
    [Pxx,F] = pwelch(x,[],[],[],Fs,'twosided');
    Pth = 2*D./(gamma^2 + (2*pi*F).^2);%See p.14 of Lindner
    figure;
    loglog(F,Pxx);
    hold on
    loglog(F,Pth);
    set(gca,'xlim',[0.01 Fs/2])
    figure;
    plot(t,x);
end