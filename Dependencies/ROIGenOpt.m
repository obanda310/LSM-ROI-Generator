function options = ROIGenOpt()
%%

H = 250;
W = 300;
h.f = figure('units','pixels','name','Select ROI-Gen Options','position',[800,480,W,H],...
    'toolbar','none','menu','none');

mTextBox = uicontrol('style','text','position',[10,H-20,W-50,20],'fontsize',11,'HorizontalAlignment','Left','fontweight','bold');
set(mTextBox,'String','Select ROI-Generator Options:');

% Create yes/no checkboxes
mTextBox = uicontrol('style','text','position',[10,H-35,200,15],'HorizontalAlignment','Left','fontweight','bold');
set(mTextBox,'String','Small Regions/Single Pixels:');

%Remove small regions?
h.c(1) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-55,300,15],'string','Remove','Value',1);

%Convert single pixels to triangles
h.c(2) = uicontrol('style','checkbox','units','pixels',...
    'position',[100,H-55,300,15],'string','Triangles','Value',0);

%Convert single pixels to squares
h.c(5) = uicontrol('style','checkbox','units','pixels',...
    'position',[180,H-55,300,15],'string','Squares','Value',0);

%Run version 2 of Mask2Poly (hidden)
h.c(3) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-95,110,15],'string','Use Old method','Value',0);

%Divide image horizontally to break open stuctures
mTextBox = uicontrol('style','text','position',[10,H-75,200,15],'HorizontalAlignment','Left','fontweight','bold');
set(mTextBox,'String','Horizontal Break Lines:');
h.c(4) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-95,W,15],'string','Use (For Breaking Open Enclosed Negative Spaces)','Value',1);
%***WIP: add option to change Hor break spacing***


%Open images stack and compress images into single file. This can be useful
%to create many negative spaces with fewer features. Not compatible with 3D
%regions.
mTextBox = uicontrol('style','text','position',[10,H-115,200,15],'HorizontalAlignment','Left','fontweight','bold');
set(mTextBox,'String','Image Stack Options');
h.c(6) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-135,W-40,15],'string','Flatten Through Z (Not Compatible with 3D ROIs)','Value',0);

%Reduce the number of rendered outputs for assessing quality. (Useful for
%large images stacks with more than ~20 images in the stack)
h.c(7) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-155,W-40,15],'string','Show Fewer Outputs (Useful for Large Stacks)','Value',1);

mTextBox = uicontrol('style','text','position',[10,H-175,200,15],'HorizontalAlignment','Left','fontweight','bold');
set(mTextBox,'String','Other Options:');

%placeholder
h.c(8) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-(2*H),W,15],'string','Use Full Borders (***Will Create Complicated ROIs***)','Value',0);


%Use full pixel trace (no shortcuts on any corners)
h.c(9) = uicontrol('style','checkbox','units','pixels',...
    'position',[10,H-195,W,15],'string','Use Full Borders (***Will Create Complicated ROIs***)','Value',0);

options = zeros(9,1);

%%

% Create OK pushbutton
h.p = uicontrol('style','pushbutton','units','pixels',...
    'position',[40,H-225,70,20],'string','OK',...
    'callback',@p_call);
uiwait(h.f);


% Pushbutton callback
    function p_call(varargin)
        vals = get(h.c,'Value');
        checked = find([vals{:}]);
        if isempty(checked)
            checked = 'none';
        end
        close;
        
    end

disp(checked)
options(checked,1) = 1;

if options(5,1)==1
    options(2,1)=0;
end

if options(6,1) == 1
    options(4,1) = 0;
end

end