function varargout = vatviewer(varargin)
% VATVIEWER MATLAB code for vatviewer.fig
%      VATVIEWER, by itself, creates a new VATVIEWER or raises the existing
%      singleton*.
%
%      H = VATVIEWER returns the handle to a new VATVIEWER or the handle to
%      the existing singleton*.
%
%      VATVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VATVIEWER.M with the given input arguments.
%
%      VATVIEWER('Property','Value',...) creates a new VATVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vatviewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vatviewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vatviewer

% Last Modified by GUIDE v2.5 24-Oct-2016 16:14:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vatviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @vatviewer_OutputFcn, ...
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


% --- Executes just before vatviewer is made visible.
function vatviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vatviewer (see VARARGIN)

% Choose default command line output for vatviewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vatviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = vatviewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_resultsFile.
function pushbutton_resultsFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resultsFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% get the .mat file from the user - it was created by running Rectify 3D
% and VATsegmentationFull2.m on one of the data sets
[resultsFileName, resultsPath] = uigetfile('*.mat','Choose results file...');
if isequal(resultsFileName,0) || isequal(resultsPath,0)
    disp('User pressed cancel')
else
    
    % display the filename (minus the full path) that the user 
    % selected in the static text 
    texthandle = handles.text_resultsFile;
    set(texthandle,'String',resultsFileName);
    
    % load the workspace from this results file and display overall
    % results as color-coded data as the initial image
    load(resultsFileName);
    disp(sprintf('Loaded results workspace from %s ...',resultsFileName));
    
    % choose the global variables we want from this set of results to use
    % in other actions from the GUI
    EAT_3D = EAT3d;
    
    % set the bounds on the slider based on the size of the EAT data
    numEATSlices = size(EAT_3D,3); % 3rd dim is slices
    sliderhandle = handles.slider_imageSlice;
    set(sliderhandle,'Max',numEATSlices);
    set(sliderhandle,'Min',1);
    
    % take the middle slice as the initial image to display
    middleSlice = floor(numEATSlices / 2);
    image(EAT_3D(:,:,middleSlice),'Parent',handles.axes_image);
    set(sliderhandle,'Value',middleSlice);
    
    % display the file selected in the command window, too
    disp(['User selected ', fullfile(resultsPath, resultsFileName)])
    
    % set appropriate value in frame number label
    set(handles.text_frameNumber,'String',...
        sprintf('Frame Number: %d',uint8(middleSlice)));

end


% --- Executes on slider movement.
function slider_imageSlice_Callback(hObject, eventdata, handles)
% hObject    handle to slider_imageSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% as slider is moved, adjust which image is displayed - round to nearest
% integer and clamp to biggest values
maxval = get(handles.slider_imageSlice,'Max');
currpos = get(handles.slider_imageSlice,'Value');
currpos = round(currpos);
if currpos < 1
    currpos = 1;
end
if currpos > maxval
    currpos = maxval;
end
set(handles.slider_imageSlice,'Value',currpos);
disp(sprintf('slider value: %f',currpos));
image(EAT_3D(:,:,uint8(currpos)),'Parent',handles.axes_image);

% set appropriate value in frame number label
set(handles.text_frameNumber,'String',...
    sprintf('Frame Number: %d',uint8(currpos)));




% --- Executes during object creation, after setting all properties.
function slider_imageSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_imageSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
