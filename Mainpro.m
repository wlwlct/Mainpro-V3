 function varargout = Mainpro(varargin)
% MAINPRO MATLAB code for Mainpro.fig
%      MAINPRO, by itself, creates a new MAINPRO or raises the existing
%      singleton*.
%
%      H = MAINPRO returns the handle to a new MAINPRO or the handle to
%      the existing singleton*.
%
%      MAINPRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINPRO.M with the given input arguments.
%
%      MAINPRO('Property','Value',...) creates a new MAINPRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mainpro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mainpro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mainpro

% Last Modified by GUIDE v2.5 24-Oct-2018 13:19:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mainpro_OpeningFcn, ...
                   'gui_OutputFcn',  @Mainpro_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Mainpro is made visible.
function Mainpro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mainpro (see VARARGIN)
clc
set(handles.Lifetime,'Value',0);
set(handles.Intensity,'Value',0);
set(handles.Wavelength,'Value',0);
set(handles.Err,'Value',0);
handles.Fluo=[];
handles.IRFI=[];
handles.IRFI_channel='0';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.program_folder=pwd;
handles.data_folder=[];
handles.Fluo_folder=[];
handles.Fluo_dtime=[];
set(handles.IRFI_load,'Value',0);
set(handles.Fluo_load,'Value',0)

handles.output = hObject;
%% Tabs Code
% Settings
TabFontSize = 10;
TabNames = {'All','Single','Data','Manually'};
FigWidth = 0.265;

% Figure resize
set(handles.figure1,'Units','normalized')
pos = get(handles. figure1, 'Position');
set(handles. figure1, 'Position', [pos(1) pos(2) FigWidth*6 pos(4)])

% Tabs Execution
handles = TabsFun(handles,TabFontSize,TabNames);

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose default command line output for Mainpro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%
%This is for generating selected button without choose.
select=get(handles.BG_A,'SelectedObject');
choice=get(select,'string');
if strcmp(choice,'A')
    set(handles.Lifetime_Intensity,'enable','off');
set(handles.Lifetime_Wavelength,'enable','off');
set(handles.Wavelength_Intensity,'enable','off');
        set(handles.Lifetime,'enable','on');
set(handles.Intensity,'enable','on');
set(handles.Wavelength,'enable','on');
set(handles.Err,'enable','on');
else
    set(handles.Lifetime_Intensity,'enable','on');
set(handles.Lifetime_Wavelength,'enable','on');
set(handles.Wavelength_Intensity,'enable','on');
    set(handles.Lifetime,'enable','off');
set(handles.Intensity,'enable','off');
set(handles.Wavelength,'enable','off');
set(handles.Err,'enable','off');
    
end

% UIWAIT makes Mainpro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = TabsFun(handles,TabFontSize,TabNames)

% Set the colors indicating a selected/unselected tab
handles.selectedTabColor=get(handles.tab1Panel,'BackgroundColor');
handles.unselectedTabColor=handles.selectedTabColor-0.1;

% Create Tabs
TabsNumber = length(TabNames);
handles.TabsNumber = TabsNumber;
TabColor = handles.selectedTabColor;
for i = 1:TabsNumber
    n = num2str(i);
    
    % Get text objects position
    set(handles.(['tab',n,'text']),'Units','normalized')
    pos=get(handles.(['tab',n,'text']),'Position');

    % Create axes with callback function
    handles.(['a',n]) = axes('Units','normalized',...
                    'Box','on',...
                    'XTick',[],...
                    'YTick',[],...
                    'Color',TabColor,...
                    'Position',[pos(1) pos(2) pos(3) pos(4)+0.01],...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);
                    
    % Create text with callback function
    handles.(['t',n]) = text('String',TabNames{i},...
                    'Units','normalized',...
                    'Position',[pos(3),pos(2)/2+pos(4)],...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','middle',...
                    'Margin',0.001,...
                    'FontSize',TabFontSize,...
                    'Backgroundcolor',TabColor,...
                    'Tag',n,...
                    'ButtonDownFcn',[mfilename,'(''ClickOnTab'',gcbo,[],guidata(gcbo))']);

    TabColor = handles.unselectedTabColor;
end
            
% Manage panels (place them in the correct position and manage visibilities)
set(handles.tab1Panel,'Units','normalized')
pan1pos=get(handles.tab1Panel,'Position');
pan3pos=get(handles.tab3Panel,'Position');
set(handles.tab1text,'Visible','off')
for i = 2:TabsNumber
    if i<=2
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan1pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off')
    end
    %%%%%%I modified to have two panel
    if i==3
    n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan3pos)
    set(handles.(['tab',n,'Panel']),'Visible','on')
    set(handles.(['tab',n,'text']),'Visible','off') 
        
    end
      
        
    if i>=4
       n = num2str(i);
    set(handles.(['tab',n,'Panel']),'Units','normalized')
    set(handles.(['tab',n,'Panel']),'Position',pan3pos)
    set(handles.(['tab',n,'Panel']),'Visible','off')
    set(handles.(['tab',n,'text']),'Visible','off') 
    end
    
    
   %%%%%I modified to have two panel
end

% --- Callback function for clicking on tab
function ClickOnTab(hObject,~,handles)
m = str2double(get(hObject,'Tag'));


%%%%%%%%%%%%%%%I modified for the code
if m<=2
for i = 1:2;
    n = num2str(i);
    if i == m
        set(handles.(['a' n]),'Color',handles.selectedTabColor)
        set(handles.(['t' n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab' n 'Panel']),'Visible','on')
    else
        set(handles.(['a' n]),'Color',handles.unselectedTabColor)
        set(handles.(['t' n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab' n 'Panel']),'Visible','off')
    end      
end
else
for i=3:handles.TabsNumber
n = num2str(i);
    if i == m
        set(handles.(['a',n]),'Color',handles.selectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.selectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','on')
    else
        set(handles.(['a',n]),'Color',handles.unselectedTabColor)
        set(handles.(['t',n]),'BackgroundColor',handles.unselectedTabColor)
        set(handles.(['tab',n,'Panel']),'Visible','off')
    end
end
end


% --- Outputs from this function are returned to the command line.
function varargout = SimpleOptimizedTabs2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Outputs from this function are returned to the command line.
function varargout = Mainpro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.histog);
cla(handles.MDL);
cla(handles.Time_trace);
cla(handles.Spectrum_all);
cla(handles.Scatter_plot);
cla(handles.fitting);
cla(handles.spectrum_single);
cla(handles.fitting_manual);
cla(handles.Manual_Residue);
cla(handles.Residue);

try
    if isempty(handles.data_folder)~=1 && isnumeric(handles.data_folder)~=1
        cd(handles.data_folder);
    end
[filename,pathname]=uigetfile('*.mat','dataset file',0,0);
handles.data_folder=pathname;
dataset=load([pathname '\' filename]);
handles.dataset=dataset.dataset;

set(handles.Location_of_file,'string',filename);
cd(handles.program_folder);
%for plotting side picture histog
axes(handles.histog)
    state_plot(handles.dataset.side.numst,handles.dataset.side.eff,handles.dataset.side.eff_fit,handles.dataset.side.MDL);
    title('Intensity Horizontal Histogram')
    
%for plotting mdl
axes(handles.MDL)
    spider_plot(handles.dataset.side.MDL,handles.dataset.side.numst);
    title('MDL vs. States')

     %for plotting Spectrum_all
    handles.xupper=length(handles.dataset.ccdt(1,3:end));
axes(handles.Spectrum_all)
le=length(handles.dataset.ccdt(1,3:end));
mesh(1:1:le,handles.dataset.ccdt(:,1),handles.dataset.ccdt(:,3:end))
colormap(jet)
view([0 0 1])
title('Spectrum')

slider_spectrum_max=length(handles.dataset.ccdt(1,3:end));
set(handles.slider_spectrum,'Value',1,'Min',1,...
                   'Max',slider_spectrum_max,...
                   'SliderStep',[1/(slider_spectrum_max-1),0.1]);   
    
    
    %for plotting time trace
axes(handles.Time_trace)
[~,~]=slider_plot(handles.dataset.side.ABStime_x,handles.dataset.side.eff,handles.dataset.side.eff_fit,handles.dataset.side.current_state);
    title(strcat('Time Trace ', ' Choose ',num2str(handles.dataset.side.numst),' states'))
 set(handles.Time_trace, 'Hittest','off','PickableParts','all');
 handles.child_handles = allchild(handles.Time_trace);
 set(handles.child_handles,'PickableParts','all','Hittest','on');
 set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});

catch
    set(handles.Location_of_file,'string','Error of loading file')
    cd(handles.program_folder);
end
% Update handles structure
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


function child_ButtonDownFcn(hObject, eventdata, handles)
%This is the one used for generating the position.....
handles.positions=[];
SR=get(handles.BG,'SelectedObject');
SorR=get(SR,'string');
Time_obj = datacursormode(gcf);
   t=rand(1,10000);
   set(Time_obj,'DisplayStyle','datatip',...
      'SnapToDataVertex','off','Enable','on');

if strcmp(SorR,'Single')
  waitforbuttonpress
    c_info = getCursorInfo(Time_obj);
              positions = c_info.Position
datacursormode off
else
    
  for i=1:2
  waitforbuttonpress
              c_info = getCursorInfo(Time_obj);
              positions(i).fd = c_info.Position
  end
                datacursormode off
end                
%Call the generate function to give the correponding spectra and lifetime....                

if isstruct(positions)~=1
xnum=positions(1,1);
%xsec=x2sec(xnum,handles.dataset.perfecttime);
xsec=round(xnum);
set(handles.Spectrum_start,'string',num2str(xsec));
    set(handles.Spectrum_end,'string',num2str(xsec));
    guidata(hObject, handles);
    PBspecSingle_Callback(hObject, eventdata, handles);
                
else
    xnum1=positions(1).fd(1,1);
%xsec1=x2sec(xnum1,handles.dataset.perfecttime);
xsec1=round(xnum1);
xnum2=positions(2).fd(1,1);
%xsec2=x2sec(xnum2,handles.dataset.perfecttime);
xsec2=round(xnum2);
    set(handles.Spectrum_start,'string',num2str(xsec1));
    set(handles.Spectrum_end,'string',num2str(xsec2));
    guidata(hObject, handles);
   PBspecSingle_Callback(hObject, eventdata, handles)
end
    



            

% --- Executes during object creation, after setting all properties.
function Location_of_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Location_of_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Lifetime.
function Lifetime_Callback(hObject, eventdata, handles)
% hObject    handle to Lifetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

scplot(handles);


% Hint: get(hObject,'Value') returns toggle state of Lifetime


% --- Executes on button press in Intensity.
function Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scplot(handles);

% Hint: get(hObject,'Value') returns toggle state of Intensity


% --- Executes on button press in Wavelength.
function Wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to Wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

scplot(handles);
% Hint: get(hObject,'Value') returns toggle state of Wavelength


% --- Executes on button press in Err.
function Err_Callback(hObject, eventdata, handles)
% hObject    handle to Err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

scplot(handles);


%I think the following would be the code for generate proper tab in GUI


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%Value=round(get(hObject,'Value'))
%set(hObject,'Value',Value);
sliderval=get(handles.slider1,'Value');
Value=round(sliderval);
Pfitting(handles.firstlevel,handles.seclevel,Value,handles);




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tau_Callback(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tau as text
%        str2double(get(hObject,'String')) returns contents of tau as a double


% --- Executes during object creation, after setting all properties.
function tau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Time_trace_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
   Time_obj = datacursormode(gcf);
   t=rand(1,10000);

   set(Time_obj,'DisplayStyle','datatip',...
      'SnapToDataVertex','off','Enable','on');
  waitforbuttonpress
              c_info = getCursorInfo(Time_obj);
              positions = c_info.Position
              


% --------------------------------------------------------------------
function txt = readpointsfcn(~,event_obj,t)
txt=[];
pos = get(event_obj,'Position');
txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)]};


% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
txt{end+1} = ['Z: ',num2str(pos(3),4)];
end
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



function uitoggletool9_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   %dcm_obj = datacursormode(gcf);
   %t=rand(1,10000);

   %set(dcm_obj,'DisplayStyle','datatip',...
    %  'SnapToDataVertex','off','Enable','on', ...
     % 'UpdateFcn',{@readpointsfcn,t});
  %pos=get(hObject,position); 
  %xsec=x2sec(pos(1),handles.dataset.perfecttime);
%handles.time=pos;


% --------------------------------------------------------------------
function uitoggletool9_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%datacursormode off


% --- Executes on button press in RB_SIngle.
function RB_SIngle_Callback(hObject, eventdata, handles)
% hObject    handle to RB_SIngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.Time_trace, 'Hittest','off','PickableParts','all');
% handles.child_handles = allchild(handles.Time_trace);
% set(handles.child_handles,'PickableParts','all','Hittest','on');
% set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});

% Hint: get(hObject,'Value') returns toggle state of RB_SIngle


% --- Executes on button press in RB_Range.
function RB_Range_Callback(hObject, eventdata, handles)
% hObject    handle to RB_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.Time_trace, 'Hittest','off','PickableParts','all');
% handles.child_handles = allchild(handles.Time_trace);
% set(handles.child_handles,'PickableParts','all','Hittest','on');
% set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});

% Hint: get(hObject,'Value') returns toggle state of RB_Range


% --- Executes on button press in PBspecSingle.
function PBspecSingle_Callback(hObject, eventdata, handles)
% hObject    handle to PBspecSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Problem 4:delete possible confusing pics
%axes(handles.spectrum_single);
        cla(handles.spectrum_single);
%        axes(handles.fitting);
cla(handles.fitting);
cla(handles.Residue)
%%%%%%%
handles.firstlevel=[];
handles.seclevel=[];

Spectrum_start=str2double(get(handles.Spectrum_start,'string'));
Spectrum_end=str2double(get(handles.Spectrum_end,'string'));

%porblem1 end larger than start
if Spectrum_start>Spectrum_end
   middle=Spectrum_start;
   Spectrum_start=Spectrum_end;
   Spectrum_end=middle;
   set(handles.Spectrum_start,'string',num2str(Spectrum_start));
   set(handles.Spectrum_end,'string',num2str(Spectrum_end));
end
%problem2, chosen value not in the range

xlower=1;
if Spectrum_end>handles.xupper
warndlg('Input data exceed the maximum range');
return
elseif Spectrum_start<xlower
    warndlg('Input data less than the minimum value');
    return
end

%Problem3 No input value
%It means we will check the input number first before we use mouse
if isnan(Spectrum_start)~=1 && isnan(Spectrum_end)~=1

    if Spectrum_start==Spectrum_end
        axes(handles.spectrum_single);
        cla(handles.spectrum_single);
slider_spectrum_val=round(Spectrum_start);
set(handles.slider_spectrum,'Value',slider_spectrum_val);

datause=get(handles.BG_datause,'SelectedObject');
ComorGen=get(datause,'string');
if strcmp(ComorGen,'Combine')
    [levelone,leveltwo]=whichconti(Spectrum_start,handles.dataset.newconti);
    
    if ~isempty(levelone) && ~isempty(leveltwo)
        plot(handles.dataset.newccdt(:,1),handles.dataset.newccdt(:,Spectrum_start+2:Spectrum_end+2),'r');
        title(['Combine from sec ' num2str(handles.dataset.newconti(levelone).co(leveltwo).subco(1,1)) ...
            ' to sec ' num2str(handles.dataset.newconti(levelone).co(leveltwo).subco(1,end))]);
    else
        plot(handles.dataset.newccdt(:,1),handles.dataset.newccdt(:,Spectrum_start+2:Spectrum_end+2));
        title('');
    end

else
        plot(handles.dataset.ccdt(:,1),handles.dataset.ccdt(:,Spectrum_start+2:Spectrum_end+2));
        title('');  
end        
        
        
        [handles.firstlevel,handles.seclevel]=tran_statenum2sec(Spectrum_start,handles.dataset.fitting);
        ft=handles.dataset.fitting(handles.firstlevel).fit(handles.seclevel).ft;
        if isstruct(ft)~=1
            axes(handles.fitting);
            title('')
            axes(handles.spectrum_single);
            set(handles.Exp_err,'string','Do not have proper lifetime for visualization');
        else
                leng=length(ft.S(:,1));
%                 axes(handles.fitting);
%                 cla(handles.fitting);
               set(handles.slider1,'Value',1,...
                   'Min',1,...
                   'Max',leng,...
                   'SliderStep',[1/(leng-1),0.1])
               %'Callback',@slider1_Callback
               %Value=get(handles.slider1,'Value');
               guidata(hObject, handles);
               Pfitting(handles.firstlevel,handles.seclevel,1,handles)
        end
    else
        axes(handles.spectrum_single);
        cla(handles.spectrum_single);
    mesh(handles.dataset.ccdt(:,Spectrum_start+2:Spectrum_end+2));
    title('')
    datacell=get(handles.table,'data');
    datacell{end+1,1}=Spectrum_start;
    datacell{end,2}=Spectrum_end;
    set(handles.table,'data',datacell);
    colormap(jet)
    end
end

if isnan(Spectrum_start)==1 || isnan(Spectrum_end)==1
        warndlg('Please type in data...');
    
end
 set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function Spectrum_start_Callback(hObject, eventdata, handles)
% hObject    handle to Spectrum_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Spectrum_start as text
%        str2double(get(hObject,'String')) returns contents of Spectrum_start as a double


% --- Executes during object creation, after setting all properties.
function Spectrum_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Spectrum_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Spectrum_end_Callback(hObject, eventdata, handles)
% hObject    handle to Spectrum_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Spectrum_end as text
%        str2double(get(hObject,'String')) returns contents of Spectrum_end as a double


% --- Executes during object creation, after setting all properties.
function Spectrum_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Spectrum_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fitting_start_Callback(hObject, eventdata, handles)
% hObject    handle to Fitting_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fitting_start as text
%        str2double(get(hObject,'String')) returns contents of Fitting_start as a double


% --- Executes during object creation, after setting all properties.
function Fitting_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fitting_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fitting_end_Callback(hObject, eventdata, handles)
% hObject    handle to Fitting_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fitting_end as text
%        str2double(get(hObject,'String')) returns contents of Fitting_end as a double


% --- Executes during object creation, after setting all properties.
function Fitting_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fitting_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PBCal.
function PBCal_Callback(hObject, eventdata, handles)
% hObject    handle to PBCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %For reading input sec and 
axes(handles.fitting_manual);
cla(handles.fitting_manual);
cla(handles.Manual_Residue);
   
%porblem1 end larger than start
datacell=get(handles.table,'data');

total=0;
[~,rowrange_zong]=size(handles.dataset.rowrange);
upper=0;
for x=1:rowrange_zong
          [~,subrowrange_zong]=size(handles.dataset.rowrange(x).rr); 
          for xx=1:subrowrange_zong
              upper=upper+1;
          end
end
upper=min([upper,handles.xupper]);
datacell(cellfun(@isempty,datacell)) = {nan};
cell_num=1;
while cell_num<=length(datacell(:,1))
    if datacell{cell_num,1}<1 
            warndlg(['Column ' num2str(cell_num) ' Input below data range'])
                                cd(handles.program_folder);
                    return
    end
    if datacell{cell_num,2}>upper
            warndlg(['Column ' num2str(cell_num) ' Input exceed data range'])
                                cd(handles.program_folder);
                    return
    end  

    a=0;b=0;
    if isnan(datacell{cell_num,1})
    a=1;
    end
       
    if isnan(datacell{cell_num,2})
    b=1;
    end
    
    apb=a+b;
    switch apb
        case 2
            datacell(cell_num,:)=[];
        case 1
            if a>b
                datacell{cell_num,1}=datacell{cell_num,2};
            else
                datacell{cell_num,2}=datacell{cell_num,1};
            end
            cell_num=cell_num+1;
        case 0
                if datacell{cell_num,1}>datacell{cell_num,2}
                middle=datacell{cell_num,1};
                datacell{cell_num,1}=datacell{cell_num,2};
                datacell{cell_num,2}=middle;
                end
                cell_num=cell_num+1;
    end    
end
%Problem2 No input value
if isempty(datacell);
    warndlg('Please type in the range you want in the table')
 cd(handles.program_folder);
return
end
set(handles.table,'data',datacell);

if isempty(handles.Fluo_dtime)~=1
                    if handles.IRFI_resolution~=handles.Fluo_resolution
                    warndlg('Resolution do not match')
                    cd(handles.program_folder);
                    return
                    end
                    
                    if handles.IRFI_channel~=handles.Fluo_channel
                        if handles.i<1
                        msgbox('Channel do not match, the calculation continues.')
                        end
                        handles.i=handles.i+1;
                    end
                    
    fitting_tau=str2double(get(handles.tau,'string'));
    fitting_shift=0;
    fitting_shift=str2double(get(handles.shift,'string'));
if  isnan(fitting_tau) || isempty(fitting_tau)
    warndlg('Please type in lifetime value')
cd(handles.program_folder);
return
end

[ccdt_combination_sum,Fluo_dtime_sub,leng_unique]=GenFluodtimesub(handles,datacell,handles.dataset.rowrange,handles.Fluo_dtime);
fittingplot=shortlffit(fitting_tau,Fluo_dtime_sub,handles.IRFI,handles.IRFI_resolution,handles,fitting_shift);
   %plot the calculated DISTORED and Fluo_sub
      if isstruct(fittingplot)==1
        axes(handles.fitting_manual);

        Fluo_change=findchangepts(fittingplot.ft(:,1),'MaxNumChanges',1,'Statistic', 'linear');
        Cal_change=findchangepts(fittingplot.ft(:,2),'MaxNumChanges',1,'Statistic', 'linear');
        plot(fittingplot.ft(:,1));hold on ;plot(fittingplot.ft(:,2));hold off;
        title(['s=' num2str(fittingplot.s,'%0.4f') '   ' 'tau=' num2str(fitting_tau) ' Combine ' num2str(leng_unique) ' seconds']);
            if isempty(Fluo_change)~=1 && isempty(Cal_change)~=1
                if Fluo_change>Cal_change
                xlim([0 Fluo_change+800]);
                else
                xlim([0 Cal_change+800]);
                end   
            end   
    %%%Plot Residue    
        axes(handles.Manual_Residue);
        plot(fittingplot.residue);
        if isempty(Fluo_change)~=1 && isempty(Cal_change)~=1
            if Fluo_change>Cal_change
            xlim([0 Fluo_change+800]);
            else
            xlim([0 Cal_change+800]);
            end   
            end   
    %%%Plot Residue
    cla(handles.spectrum_single);
axes(handles.spectrum_single);
plot(handles.dataset.ccdt(:,1),ccdt_combination_sum);
title(['summation mode with ' num2str(leng_unique) ' seconds']);
    
    
   else
       warndlg('Data would not provide enough points or S/N signal')
   end
else
set(handles.Exp_err,'String' ,'Please input the Fluo datafile if you need to calculate lifetime');

[ccdt_combination_sum,~,leng_unique]=GenFluodtimesub(handles,datacell,handles.dataset.rowrange,handles.Fluo_dtime);
cla(handles.spectrum_single);
axes(handles.spectrum_single);
plot(handles.dataset.ccdt(:,1),ccdt_combination_sum);
title(['summation mode with ' num2str(leng_unique) ' seconds']);

end
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

    

function PBFLuo_Callback(hObject,eventdata,handles)
% hObject    handle to PBCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Fluo=[];
  set(handles.Fluo_load,'Value',0);
try
    %This is for loading fitting FLuo data
if isempty(handles.Fluo_folder)~=1
    cd(handles.Fluo_folder);
end
if isempty(handles.IRFI_channel)
    warndlg('Try Input IRF file first to get channel information')
    cd(handles.program_folder);
    return
end

[Fluofilename,Fluopathname]=uigetfile('*.mat','Fluodataset file',0,0);
handles.Fluo_folder=Fluopathname;
cd(handles.program_folder)
[Fluo,handles.Fluo_resolution]=PTUim([Fluopathname '\' Fluofilename]);
handles.Fluo_channel=handles.IRFI_channel;
handles.Fluo_dtime=GET_Dtime(Fluo,str2num(handles.Fluo_channel),'marker');
set(handles.Channel_Representation,'String',handles.Fluo_channel);
set(handles.Resolution_representation,'String',num2str(handles.Fluo_resolution))
    %set(handles.Location_of_file,'string',Fluofilename);
    handles.i=0;
    guidata(hObject, handles);
    cd(handles.program_folder)
    set(handles.Fluo_load,'Value',1);
catch
    set(handles.Exp_err,'string','Erro loading Fluo files (Maybe due to channel of IRFI)')
    cd(handles.program_folder);
end
set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over PBFLuo.
function PBFLuo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to PBFLuo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function PBFLuo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PBFLuo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Lifetime_Intensity.
function Lifetime_Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to Lifetime_Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%guidata(hObject, handles);

scplot(handles);

% Hint: get(hObject,'Value') returns toggle state of Lifetime_Intensity


% --- Executes on button press in Lifetime_Wavelength.
function Lifetime_Wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to Lifetime_Wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%guidata(hObject, handles);

scplot(handles);

% Hint: get(hObject,'Value') returns toggle state of Lifetime_Wavelength


% --- Executes on button press in Wavelength_Intensity.
function Wavelength_Intensity_Callback(hObject, eventdata, handles)
% hObject    handle to Wavelength_Intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.Life=get(handles.Lifetime,'Value');
%handles.Int=get(handles.Intensity,'Value');
%handles.wave=get(handles.Wavelength,'Value');
%handles.err=get(handles.Err,'Value');
%handles.lifetime_intensity=get(handles.Lifetime_Intenstiy,'Value');
%handles.lifetime_wavelength=get(handles.Lifetime_Wavelength,'Value');
%handles.wavelength_intensity=get(handles.Wavelength_Intenstiy,'Value');
%guidata(hObject, handles);
%axes(handles.Scatter_plot)
scplot(handles);
% Hint: get(hObject,'Value') returns toggle state of Wavelength_Intensity


% --- Executes when selected object is changed in BG_A.
function BG_A_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in BG_A 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select=get(handles.BG_A,'SelectedObject');
choice=get(select,'string');
if strcmp(choice,'A')
    set(handles.Lifetime_Intensity,'enable','off');
set(handles.Lifetime_Wavelength,'enable','off');
set(handles.Wavelength_Intensity,'enable','off');
        set(handles.Lifetime,'enable','on');
set(handles.Intensity,'enable','on');
set(handles.Wavelength,'enable','on');
set(handles.Err,'enable','on');
else
    set(handles.Lifetime_Intensity,'enable','on');
set(handles.Lifetime_Wavelength,'enable','on');
set(handles.Wavelength_Intensity,'enable','on');
    set(handles.Lifetime,'enable','off');
set(handles.Intensity,'enable','off');
set(handles.Wavelength,'enable','off');
set(handles.Err,'enable','off');
end
scplot(handles);



% --- Executes during object creation, after setting all properties.
function BG_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BG_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function uitoggletool9_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to slider_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

slider_spectrum_val=get(handles.slider_spectrum,'Value');
slider_spectrum_val=round(slider_spectrum_val);
set(handles.slider_spectrum,'Value',slider_spectrum_val)
set(handles.Spectrum_start,'string',num2str(slider_spectrum_val));
    set(handles.Spectrum_end,'string',num2str(slider_spectrum_val));
    guidata(hObject, handles);
                PBspecSingle_Callback(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function slider_spectrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Scatter_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.


% --- Executes on button press in Import_IRFI.
function Import_IRFI_Callback(hObject, eventdata, handles)
% hObject    handle to Import_IRFI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.IRFI=[];
  set(handles.IRFI_load,'Value',0);
try
    %This is for loading fitting FLuo data
if isempty(handles.Fluo_folder)~=1
    cd(handles.Fluo_folder);
end
    
[IRFIfilename,IRFIpathname]=uigetfile('*.mat','IRFdata file',0,0);
cd(handles.program_folder)
handles.IRFI_folder=IRFIpathname;
[handles.IRFI,handles.IRFI_resolution]=PTUim([IRFIpathname '\' IRFIfilename]);
if length(handles.IRFI(1,:))~=1
    warndlg('This is not the correct format of IRF')
    cd(handles.program_folder)
    return
end

handles.IRFI_channel=IRFIfilename(length(IRFIfilename)-4);   


%set(handles.Location_of_file,'string',Fluofilename);
handles.i=0;
    guidata(hObject, handles);
    cd(handles.program_folder)
      set(handles.IRFI_load,'Value',1);
      set(handles.Resolution_representation,'String',num2str(handles.IRFI_resolution));
      set(handles.Channel_Representation,'String',num2str(handles.IRFI_channel));
catch
    warndlg('Error of loading file')
    cd(handles.program_folder);
end
 set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in IRFI_load.
function IRFI_load_Callback(hObject, eventdata, handles)
% hObject    handle to IRFI_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IRFI_load


% --- Executes on button press in Fluo_load.
function Fluo_load_Callback(hObject, eventdata, handles)
% hObject    handle to Fluo_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Fluo_load



function Resolution_representation_Callback(hObject, eventdata, handles)
% hObject    handle to Resolution_representation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Resolution_representation as text
%        str2double(get(hObject,'String')) returns contents of Resolution_representation as a double


% --- Executes during object creation, after setting all properties.
function Resolution_representation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Resolution_representation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Channel_Representation_Callback(hObject, eventdata, handles)
% hObject    handle to Channel_Representation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel_Representation as text
%        str2double(get(hObject,'String')) returns contents of Channel_Representation as a double


% --- Executes during object creation, after setting all properties.
function Channel_Representation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel_Representation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function shift_Callback(hObject, eventdata, handles)
% hObject    handle to shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shift as text
%        str2double(get(hObject,'String')) returns contents of shift as a double


% --- Executes during object creation, after setting all properties.
function shift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_timetrace.
function save_timetrace_Callback(hObject, eventdata, handles)
% hObject    handle to save_timetrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_timetrace


% --- Executes on button press in save_mesh.
function save_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to save_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_mesh


% --- Executes on button press in save_2D.
function save_2D_Callback(hObject, eventdata, handles)
% hObject    handle to save_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_2D


% --- Executes on button press in save_scplot.
function save_scplot_Callback(hObject, eventdata, handles)
% hObject    handle to save_scplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_scplot


% --- Executes on button press in save_autofit.
function save_autofit_Callback(hObject, eventdata, handles)
% hObject    handle to save_autofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_autofit


% --- Executes on button press in save_manualfitting.
function save_manualfitting_Callback(hObject, eventdata, handles)
% hObject    handle to save_manualfitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_manualfitting


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveplot(handles);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_save.
function button_save_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PB_addrow.
function PB_addrow_Callback(hObject, eventdata, handles)
% hObject    handle to PB_addrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=get(handles.table,'data');
data(end+1,:)={[]};
set(handles.table,'data',data);



% --- Executes on button press in PB_mancalculate.
function PB_mancalculate_Callback(hObject, eventdata, handles)
% hObject    handle to PB_mancalculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_deleterow.
function pb_deleterow_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deleterow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacell=get(handles.table,'data');
datacell(1,:)=[];
set(handles.table,'data',datacell);


% --- Executes during object creation, after setting all properties.
function RB_Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RB_Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.Time_trace, 'Hittest','off','PickableParts','all');
% handles.child_handles = allchild(handles.Time_trace);
% set(handles.child_handles,'PickableParts','all','Hittest','on');
% set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});


% --- Executes during object creation, after setting all properties.
function RB_SIngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RB_SIngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.Time_trace, 'Hittest','off','PickableParts','all');
% handles.child_handles = allchild(handles.Time_trace);
% set(handles.child_handles,'PickableParts','all','Hittest','on');
% set(handles.child_handles,'ButtonDownFcn',{@child_ButtonDownFcn,handles});



function EB_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to EB_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EB_threshold as text
%        str2double(get(hObject,'String')) returns contents of EB_threshold as a double
scplot(handles);

% --- Executes during object creation, after setting all properties.
function EB_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EB_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in combine.
function combine_Callback(hObject, eventdata, handles)
% hObject    handle to combine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of combine
scplot(handles);
PBspecSingle_Callback(hObject, eventdata, handles);


% --- Executes on button press in General.
function General_Callback(hObject, eventdata, handles)
% hObject    handle to General (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of General
scplot(handles);
PBspecSingle_Callback(hObject, eventdata, handles);