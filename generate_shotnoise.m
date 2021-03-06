function out = generate_shotnoise( single_event, r_set, fs, Tsim, varargin )
%Create Poisson process convolved with a single event
%See poisson_process_test for an example
    if nargin == 0 %test purpose
        close all;
        dat_path = '/Users/dtakeshi/Documents/MATLAB/RodNoiseModel/RodData';
        fn_fit = 'WT_fit.txt';
        dat_rod =  load(fullfile(dat_path, fn_fit));
        t = dat_rod(:,1);
        g0 = dat_rod(:,2)';
        dt = mean(diff(t));
        fs = 1/dt;
        single_sign = -1;
        

        Tsim = 500;
        t = 0:dt:Tsim+2;
        r_set = [0.01 0.1];
% 
%         A = 1.2;
%         tau = 0.01;
%         npt_g = 50*round(tau/dt);
%         g0 = -A*exp(-(0:npt_g)*dt/tau);%single event
        g_zero = zeros(1,2*length(g0));
        single_event = [g_zero g0 g_zero];
        t_g = dt*[0:length(single_event)-1];
        
        
        
    end
    if ~exist('single_sign','var')
        single_sign = 1;
    end
    if nargin >= 5
       single_sign = varargin{1}; 
    end
    dt = 1/fs;
    t = 0:dt:Tsim+2;%add 1sec buffer
    M = zeros(size(r_set));
    V = M;
%     PS_single = calc_psd(single_event,1/dt,'fft');%onsided pectrum divided by T
%     T_single = length(single_event)*dt;
%     PS_single.Pxx = PS_single.Pxx*T_single/2;%"un-normalize" the spectrum
    %% zero padding & unnormalized PSD
    PS_single= calc_unnormalize_psd( single_event, 1/dt );
    Area_single = single_sign*sum(single_event)*dt;
    Area_sq_single = sum(single_event.^2)*dt;
    
    PS_sequence = cell(size(r_set));
    for n=1:length(r_set)
        r = r_set(n);
        p = r*dt;
        y = zeros(size(t));
        bi = rand(size(t));
        event = bi < p;
        y(event) = 1;%As this is a discrete covolution
        z = conv(y,sign(single_sign)*single_event,'same');
        idx_used = t>1 & t<Tsim+1;
        t_used = t(idx_used);
        z_used = z(idx_used);
        M(n) = mean(z_used);
        V(n) = var(z_used);
        
        % powerspecturm
        sc = 2*r;%Baylor, Matthews,Yau (1980) JP, Eq6 on p.599
        PS_sequence{n} = calc_psd( z_used, fs, 'pwelch' );
        
        % plot
        if nargin == 0
            subplot(length(r_set),1,n)
            plot(t_used,z_used)
            ttl_str = sprintf('%g events/sec',r)
            title(ttl_str)
        end
        
    end
    %% Store results
    out.Process.Power = PS_sequence;
    out.Process.Mean = M;
    out.Process.Var = V;
    out.Single.Area = Area_single;
    out.Single.AreaSq = Area_sq_single;
    out.Single.Power =  PS_single;
    if nargin==0
        xlabel('Time')
        ah = findobj(gcf,'type','axes')
        set(ah,'ylim',[min(z_used) 0],'xlim',[t_used(1) t_used(end)]);
        set(ah,'fontsize',18)
    end
    %prediction
%     M_prd = r_set*Area_single;
%     V_prd = r_set*Area_sq_single;%see Rice(1944), p296 (1.2-3)
end



