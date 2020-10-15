function PushB(src,event)

    if src.Position(1) == 0
        display('Left')
        tstart = 10;
        tstop = 20;
    elseif src.Position(1) ~= 0
        display('Right')
        tstart = 0;
        tstop = 10;
    end
    %plot(raw_vals);
        subplot('Position',[.1 .7 .8 .25]);
        plot_raw_data(tstart,tstop);
        subplot('Position',[.1 .3 .8 .25]);
        plot_raw_data(tstart,tstop,true);
    
   
end