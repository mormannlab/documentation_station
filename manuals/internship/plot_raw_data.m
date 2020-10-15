function plot_raw_data(tstart,tstop,filter)
%plot_raw_data(tstart,tstop,filter)
    if ~exist('filter','var') 
        filter = false;
    end
    

    raw_vals = raw_data(tstart,tstop);
    if filter
        passband=[300 3000];    %passband in Hz
        sr=32768; 
        %Setting up a second order elliptic filter
        [b a]=ellip(2, 0.1, 40, passband.*2./sr);
        %Filter signal (bidirectional)
        filtered_signal=filtfilt(b,a,raw_vals);
        data = filtered_signal;
    else
        data = raw_vals;
    end
    
    plot(data);
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    



end