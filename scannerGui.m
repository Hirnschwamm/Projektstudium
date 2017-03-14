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

% Last Modified by GUIDE v2.5 14-Mar-2017 20:29:57

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
handles.objectPoints = [];

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
    scanLinePoints = extractLineFromRGBMask(maskRGB);
    cameraPoints = getXYCameraCoordinates(scanLinePoints, handles);
    worldPoints = getXYZCameraCoordinates(cameraPoints, str2double(get(handles.offsetEdit, 'String')) + 1);
    
    plotImageAndScanLine(handles.ImagePanel, handles.CurrentImage, scanLinePoints);
    plotPoints(handles.PointCloudPanel, worldPoints);
    
    guidata(hObject, handles);
end

% --- Executes on button press in acquireImageAndSave.
function acquireImageAndSave_Callback(hObject, eventdata, handles)
% hObject    handle to acquireImageAndSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles, 'CurrentWebcam'))
    image = snapshot(handles.CurrentWebcam);
    [maskBlackWhite, maskRGB] = createMask(image, handles);
    handles.CurrentImage = maskRGB;
    scanLinePoints = extractLineFromRGBMask(maskRGB);
    cameraPoints = getXYCameraCoordinates(scanLinePoints, handles);
    worldPoints = getXYZCameraCoordinates(cameraPoints, str2double(get(handles.offsetEdit, 'String')) + 1);
    handles.objectPoints = vertcat(handles.objectPoints, worldPoints);
    
    plotImageAndScanLine(handles.ImagePanel, handles.CurrentImage, scanLinePoints);
    plotPoints(handles.PointCloudPanel, handles.objectPoints);
    set(handles.offsetEdit, 'String', num2str((str2double(get(handles.offsetEdit, 'String')) + 1)));
    guidata(hObject, handles);
end

function plotImageAndScanLine(axesHandle, image, scanlinePoints)
rotation = rotate3d;
rotation.Enable = 'on';
axes(axesHandle);
imshow(image);
hold on;
plot(scanlinePoints(:,1),scanlinePoints(:,2), 'x', 'color', 'white'); 
setAllowAxesRotate(rotation,axesHandle,false);

function plotPoints(axesHandle, points)
axes(axesHandle);
cla();
axis([-600 600 -3000 3000 120 160]);
hold(axesHandle,'on')
grid on;
set(gca,'Color',[1.0 1.0 1.0]);
scatter3(points(:,1), points(:,3), points(:,2), '.');
xlabel('X');
ylabel('Z');
zlabel('Y');


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



function offsetEdit_Callback(hObject, eventdata, handles)
% hObject    handle to offsetEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offsetEdit as text
%        str2double(get(hObject,'String')) returns contents of offsetEdit as a double


% --- Executes during object creation, after setting all properties.
function offsetEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
