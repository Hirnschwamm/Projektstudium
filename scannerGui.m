function varargout = scannerGui(varargin)
% SCANNERGUI MATLAB code for scannerGui.fig
%      SCANNERGUI, by itself, creates a new SCANNERGUI or raises the existing
%      singleton*.
%
%      H = SCANNERGUI returns the handle to a new SCANNERGUI or the handle to
%      the existing singleton*.
%
%      SCANNERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCANNERGUI.M with the given input arguments.
%
%      SCANNERGUI('Property','Value',...) creates a new SCANNERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scannerGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scannerGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scannerGui

% Last Modified by GUIDE v2.5 17-Dec-2016 18:45:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scannerGui_OpeningFcn, ...
                   'gui_OutputFcn',  @scannerGui_OutputFcn, ...
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


% --- Executes just before scannerGui is made visible.
function scannerGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scannerGui (see VARARGIN)

handles.redMin = 0;
handles.redMax = 255;
handles.greenMin = 0;
handles.greenMax = 255;
handles.blueMin = 0;
handles.blueMax = 255;
handles.cameraParams = calibrateCamera();
handles.inverseIntrinsicCameraMatrix = inv(handles.cameraParams.IntrinsicMatrix);

camlist = webcamlist;
for c = camlist'
    uimenu(handles.MenuWebcams, 'Label', strjoin(c), 'Callback',{@chooseActiveWebcam handles});
end

cla(handles.ImagePanel);
uistack(handles.ImagePanel, 'bottom');

% Choose default command line output for scannerGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes scannerGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scannerGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in acquireImage.
function acquireImage_Callback(hObject, eventdata, handles)
% hObject    handle to acquireImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles, 'CurrentWebcam'))
    image = snapshot(handles.CurrentWebcam);
    [maskBlackWhite, maskRGB] = createMask(image, handles);
    handles.CurrentImage = maskRGB;
    points = extractLineFromRGBMask(maskRGB);
    cameraPoints = getCameraCoordinates(image, points, handles);
    FindZCoordinate(image, cameraPoints, handles);
    
    %axes(handles.ImagePanel);   
    %imshow(handles.CurrentImage);
    %hold on;
    %plot(points(:,1),points(:,2), 'x', 'color', 'white');
    guidata(hObject, handles);
end

function chooseActiveWebcam(hObject, eventdata, handles)
handles.CurrentWebcam = webcam(hObject.Label);
handles.WebcamNameDisplayText.String = hObject.Label;
guidata(hObject, handles);


% --- Executes on slider movement.
function maxThresholdSliderGreen_Callback(hObject, eventdata, handles)
% hObject    handle to maxThresholdSliderGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.greenMax = 255 - (get(hObject, 'Value') * 255);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxThresholdSliderGreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxThresholdSliderGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxThreshholdSliderRed_Callback(hObject, eventdata, handles)
% hObject    handle to maxThreshholdSliderRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.redMax = 255 - (get(hObject, 'Value') * 255);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxThreshholdSliderRed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxThreshholdSliderRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function maxThresholdSliderBlue_Callback(hObject, eventdata, handles)
% hObject    handle to maxThresholdSliderBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.blueMax = 255 - (get(hObject, 'Value') * 255);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function maxThresholdSliderBlue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxThresholdSliderBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function minThresholdSliderRed_Callback(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.redMin = get(hObject, 'Value') * 255;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minThresholdSliderRed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function minThresholdSliderGreen_Callback(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.greenMin = get(hObject, 'Value') * 255;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function minThresholdSliderGreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function minThresholdSliderBlue_Callback(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.blueMin = get(hObject, 'Value') * 255;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function minThresholdSliderBlue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minThresholdSliderBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
