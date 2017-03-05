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

% Last Modified by GUIDE v2.5 05-Mar-2017 21:41:35

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
    worldPoints = GetPointsInXYZSpace(image, cameraPoints, handles);
    
    rotation = rotate3d;
    rotation.Enable = 'on';
    
    axes(handles.ImagePanel);
    imshow(handles.CurrentImage);
    hold on;
    plot(points(:,1),points(:,2), 'x', 'color', 'white'); 
    setAllowAxesRotate(rotation,handles.ImagePanel,false);
   
    axes(handles.PointCloudPanel);
    scatter3(worldPoints(:,1), worldPoints(:,2), worldPoints(:,3),'.');
    
    guidata(hObject, handles);
end

function chooseActiveWebcam(hObject, eventdata, handles)
handles.CurrentWebcam = webcam(hObject.Label);
handles.WebcamNameDisplayText.String = hObject.Label;
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

function minThresholdSliderRed_Callback(hObject, eventdata, handles)
handles.redMin = get(hObject, 'value') * 255;
guidata(hObject, handles);
