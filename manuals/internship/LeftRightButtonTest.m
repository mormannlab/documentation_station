function LeftRightButtonTest()

    hFig = figure;
    ButtonL = uicontrol('Parent',hFig,'Style','pushbutton', 'String','Left','Units','normalized','Position',[0.0 0.0 0.4 0.2], ...
    'Visible','on','CallBack',  @Pushleft);
    function Pushleft(source, event)
    	display('Left')
    end
     ButtonR=uicontrol('Parent',hFig,'Style','pushbutton', 'String','Right','Units','normalized','Position',[1-0.4 0.0 0.4 0.2], ...
     'Visible','on','CallBack',  @Pushright);
     function Pushright(source,event)
     	display('Right')
     end

end
