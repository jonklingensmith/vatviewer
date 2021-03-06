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

% Last Modified by GUIDE v2.5 18-Nov-2016 15:20:41

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

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% Choose default command line output for vatviewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vatviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% set data type to EAT by default on opening
WHICH_TYPE = 'EAT_3D';
TRACING_WHICH_TYPE = 'EAT_3D';

% set the radio button to EAT initially upon loading new data
set(handles.uibuttongroup_fatType,'SelectedObject',...
    handles.radiobutton_EAT);

% set the colormap radio button to gray initially
set(handles.uibuttongroup_Colormap,'SelectedObject',...
    handles.radiobutton_Gray);
colormap('gray');

% disable boundary button
set(handles.pushbutton_FindBoundaries,'Enable','off');

% disable tracing button
set(handles.togglebutton_TraceBoundaries,'Enable','off');

% set flag for loaded data to false
BOOL_LOADED_DATA = 0;

% set flag for tracing to false
BOOL_TRACING_BOUNDARIES = 0;



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
    
    % display hourglass cursor while loading
    set(handles.figure1,'pointer','watch');
    drawnow;
    
    % display the filename (minus the full path) that the user 
    % selected in the static text 
    texthandle = handles.text_resultsFile;
    set(texthandle,'String',resultsFileName);
    
    % load the workspace from this results file and display overall
    % results as color-coded data as the initial image
    load(resultsFileName);
    disp(sprintf('Loaded results workspace from %s ...',resultsFileName));
    
    % copy correct data type to the one we will use for viewing
    vatviewerLoadTissueData();
    vatviewerSetTissueType();
   
    % set the bounds on the slider based on the size of the EAT data
    numSlices = size(VOL_3D,3); % 3rd dim is slices
    sliderhandle = handles.slider_imageSlice;
    set(sliderhandle,'Max',numSlices);
    set(sliderhandle,'Min',1);
    set(sliderhandle,'SliderStep',[1/(numSlices-1) 10/(numSlices-1)]);

    % take the middle slice as the initial image to display
    middleSlice = floor(numSlices / 2);
    imagesc(VOL_3D(:,:,middleSlice),'Parent',handles.axes_image);
    set(sliderhandle,'Value',middleSlice);
    
    % display the file selected in the command window, too
    disp(['User selected ', fullfile(resultsPath, resultsFileName)])
    
    % set appropriate value in frame number label
    set(handles.text_frameNumber,'String',...
        sprintf('Frame Number: %d',uint8(middleSlice)));
    
    % reset back to pointer cursor
    set(handles.figure1,'pointer','arrow');
    
    % set the fat type radio button to EAT initially upon loading new data
    set(handles.uibuttongroup_fatType,'SelectedObject',...
        handles.radiobutton_EAT);

    % set the colormap radio button to gray initially
    set(handles.uibuttongroup_Colormap,'SelectedObject',...
        handles.radiobutton_Gray);
    colormap('gray');

    % enable boundaries button
    set(handles.pushbutton_FindBoundaries,'Enable','on');

    % disable tracing button until non-binary image type is chosen
    set(handles.togglebutton_TraceBoundaries,'Enable','off');
    
    % set up button down and button up handlers
    set(gcf,'WindowButtonDownFcn',@buttonDown);
    set(gcf,'WindowButtonUpFcn',@buttonUp);
    
    % set flag for loaded data to true
    BOOL_LOADED_DATA = 1;
    BOOL_TRACING_BOUNDARIES = 0;
    RESULTS_FILENAME = resultsFileName;
    BOOL_BUTTON_DOWN = 0;
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
%set(handles.slider_imageSlice,'Value',currpos);
disp(sprintf('slider value: %f',currpos));
imagesc(VOL_3D(:,:,uint8(round(currpos))),'Parent',handles.axes_image);

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



% --- Executes when selected object is changed in uibuttongroup_fatType.
function uibuttongroup_fatType_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_fatType 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

if BOOL_LOADED_DATA
    
    % get current selection
    stringSelection = get(hObject,'String');
    
    % set the correct data and reload 
    switch stringSelection
        case 'EAT'
            disp('EAT selected.');
            WHICH_TYPE = 'EAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'PAAT'
            disp('PAAT selected.');
            WHICH_TYPE = 'PAAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'CAT'
            disp('CAT selected.');
            WHICH_TYPE = 'CAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'SCAT'
            disp('SCAT selected.');
            WHICH_TYPE = 'SCAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');            
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'TAT'
            disp('TAT selected.');
            WHICH_TYPE = 'TAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');            
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'VAT'
            disp('VAT selected.');
            WHICH_TYPE = 'VAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'IMAT'
            disp('IMAT selected.');
            WHICH_TYPE = 'IMAT_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'ORGANS'
            disp('ORGANS selected.');
            WHICH_TYPE = 'ORGANS_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'VOIDS'
            disp('VOIDS selected.');
            WHICH_TYPE = 'VOIDS_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'LUNGS'
            disp('LUNGS selected.');
            WHICH_TYPE = 'LUNGS_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'HEART'
            disp('HEART selected.');
            WHICH_TYPE = 'HEART_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'AORTA'
            disp('AORTA selected.');
            WHICH_TYPE = 'AORTA_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','on');
            set(handles.togglebutton_TraceBoundaries,'Enable','off');
        case 'Fat Only Image'
            disp('Fat Only Image selected.');
            WHICH_TYPE = 'FATONLY_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','off');
            set(handles.togglebutton_TraceBoundaries,'Enable','on');
        case 'Water Only Image'
            disp('Water Only Image selected.');
            WHICH_TYPE = 'WATERONLY_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','off');
            set(handles.togglebutton_TraceBoundaries,'Enable','on');
        case 'Fat Fraction'
            disp('Fat Fraction selected.');
            WHICH_TYPE = 'FATFRACTION_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','off');
            set(handles.togglebutton_TraceBoundaries,'Enable','on');
        case 'Water Fraction'
            disp('Water Fraction selected.');
            WHICH_TYPE = 'WATERFRACTION_3D';
            set(handles.pushbutton_FindBoundaries,'Enable','off');
            set(handles.togglebutton_TraceBoundaries,'Enable','on');
        otherwise
    end

    % now use the function to update the actual 3D data - does basically
    % same thing as above, but also sets data - could remove later???
    vatviewerSetTissueType();

    % now need to reset slider range and show correct data
    numSlices = size(VOL_3D,3); % 3rd dim is slices
    disp(sprintf('Number of slices: %d',numSlices));
    sliderhandle = handles.slider_imageSlice;
    set(sliderhandle,'Max',numSlices);
    set(sliderhandle,'Min',1);
    set(sliderhandle,'SliderStep',[1/(numSlices-1) 10/(numSlices-1)]);
    
    % keep current location of slider position unless it's out of bounds
    % for the new image set - if so, set to closest value
    valueToSet = get(sliderhandle,'Value');
    if (valueToSet > numSlices)
        valueToSet = floor(numSlices / 2);
    end
    
    % take the middle slice as the initial image to display
    imagesc(VOL_3D(:,:,uint8(valueToSet)),'Parent',handles.axes_image);
    set(sliderhandle,'Value',valueToSet);
    
    % set appropriate value in frame number label
    set(handles.text_frameNumber,'String',...
        sprintf('Frame Number: %d',uint8(valueToSet)));

else
    errordlg('Load results data before selecting type!','Load Error');
end
    


% --- Executes when selected object is changed in uibuttongroup_Colormap.
function uibuttongroup_Colormap_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_Colormap 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% set colormap based on value of radio button group selection
if BOOL_LOADED_DATA
    
    % get current selection
    stringSelection = get(hObject,'String');
    
    % set the correct data and reload 
    switch stringSelection
        case 'Parula'
            disp('Parula colormap selected.');
            colormap('Parula');
        case 'Hot'
            disp('Hot colormap selected.');
            colormap('Hot');
        case 'Gray'
            disp('Gray colormap selected.');
            colormap('Gray');
        case 'Bone'
            disp('Bone colormap selected.');
            colormap('Bone');
        otherwise
    end
else
    errordlg('Load results data before selecting a colormap!','Load Error');
end


% --- Executes on button press in pushbutton_FindBoundaries.
function pushbutton_FindBoundaries_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FindBoundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% pull out current frame of data
currSliceNum = get(handles.slider_imageSlice,'Value');
disp(sprintf('Current frame for boundary tracing: %d',currSliceNum));
imageSlice = VOL_3D(:,:,currSliceNum);

% convert image to true binary
binImage = (imageSlice>0);
clear imageSlice;

% trace boundaries and overlay results
[B,L] = bwboundaries(binImage,8,'holes');
hold on;
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1),'y','LineWidth',2);
end
hold off;


% --- Executes on button press in togglebutton_TraceBoundaries.
function togglebutton_TraceBoundaries_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_TraceBoundaries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_TraceBoundaries
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    
    % toggle button is pressed
    disp('Trace Boundaries toggle button pressed');
    BOOL_TRACING_BOUNDARIES = 1;
    
    % now setup the windowbuttonmotionfcn
    set(gcf,'windowbuttonmotionfcn',@mouseMove);
    
elseif button_state == get(hObject,'Min')
    
    % toggle button is not pressed
    disp('Trace Boundaries toggle button NOT pressed');
    BOOL_TRACING_BOUNDARIES = 0;
    
    % clear the windowbuttonmotionfcn
    set(gcf,'windowbuttonmotionfcn','');
end


% --- Executes on button press in pushbutton_WriteJPGs.
function pushbutton_WriteJPGs_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_WriteJPGs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% only proceed if loaded data
if BOOL_LOADED_DATA

    % output message for the callback
    disp('Write JPGs pressed.');

    % get number of frames valid in current 3D image data
    numImageFrames = size(VOL_3D,3);

    % loop through image frames, create filename and write JPG image
    for i=1:numImageFrames

        % create filename based on the type and the number of frame
        dotLoc = find(RESULTS_FILENAME == '.');
        baseName = RESULTS_FILENAME(1:dotLoc-1);
        fileNameToWrite = strcat(baseName,'_',WHICH_TYPE,'_',...
            sprintf('%03d',i),'.jpg');
                
        % grab the image frame
        imageToWrite = VOL_3D(:,:,i);
        
        % write this slice to file
        disp(sprintf('Writing file %s ...',fileNameToWrite));
        imwrite(imageToWrite,fileNameToWrite,'Quality',100);
    end
else
    errordlg('Load results data before selecting Write JPGs!','Load Error');    
end


% --- handler for mouse movement
function mouseMove(object,eventdata)
%
%

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% only manage tracing if mouse button down
if BOOL_BUTTON_DOWN


    % write out mouse location as temp test
    mouseLocation = get(gca, 'CurrentPoint');
    disp(sprintf('Mouse location: %03d,%03d',int16(mouseLocation(1,1)),...
        int16(mouseLocation(1,2))));
    
    % add the point to the current boundary data
    AddPointToCountours(TRACING_WHICH_TYPE,mouseLocation)
    
    % draw line up to this point
    DrawCountours(TRACING_WHICH_TYPE);
end


% --- handler for mouse button down
function buttonDown(object,eventdata)
%
%

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% trace message
disp('Mouse button down...');

% set flag appropriately
BOOL_BUTTON_DOWN = 1;


% --- handler for mouse button up
function buttonUp(object,eventdata)
%
%

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% trace message
disp('Mouse button up...');

% set flag appropriately
BOOL_BUTTON_DOWN = 0;


% --- Executes when selected object is changed in uibuttongroup_TracingType.
function uibuttongroup_TracingType_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_TracingType 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% get current selection
stringSelection = get(hObject,'String');

% set the correct data and reload 
switch stringSelection
    case 'Tracing EAT'
        disp('Tracing EAT selected.');
        TRACING_WHICH_TYPE = 'EAT_3D';
    case 'Tracing SCAT'
        disp('Tracing SCAT selected.');
        TRACING_WHICH_TYPE = 'SCAT_3D';
    case 'Tracing VAT'
        disp('Tracing VAT selected.');
        TRACING_WHICH_TYPE = 'VAT_3D';
    case 'Tracing PAAT'
        disp('Tracing PAAT selected.');
        TRACING_WHICH_TYPE = 'PAAT_3D';
    case 'Tracing PAT'
        disp('Tracing PAT selected.');
        TRACING_WHICH_TYPE = 'PAT_3D';
    otherwise
end
    
