function TestMyButtons()
    hFig = figure;
    ButtonL=uicontrol('Parent',hFig,'Style','pushbutton', 'String','Next >>','Units','normalized','Position',[0.0 0.0 0.4 0.2], ...
    'Visible','on','CallBack',  @PushB);
    ButtonR=uicontrol('Parent',hFig,'Style','pushbutton', 'String','<< Prev','Units','normalized','Position',[1-0.4 0.0 0.4 0.2], ...
    'Visible','on','CallBack',  @PushB);
    
    %subplot('Position',[.1 .4 .8 .4]);
    
    subplot('Position',[.1 .7 .8 .25]);
    plot_raw_data(0,10);
    subplot('Position',[.1 .3 .8 .25]);
    plot_raw_data(0,10,true);
    
end
    

