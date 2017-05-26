function varargout = scanUtilityGUI(varargin)
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

% Last Modified by GUIDE v2.5 17-Apr-2017 20:04:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scanUtilityGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @scanUtilityGUI_OutputFcn, ...
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
function scanUtilityGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scannerGui (see VARARGIN)

handles.currentImageNumber = 0; %running count for the images taken so far

%get all available webcams and save them in a menu, so the user choose
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
function varargout = scanUtilityGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function chooseActiveWebcam(hObject, eventdata, handles)
%Specifies which webcam should be used to shoot the images
handles.CurrentWebcam = webcam(hObject.Label);
handles.WebcamNameDisplayText.String = hObject.Label;
guidata(hObject, handles);


% --- Executes on button press in previewButton.
function previewButton_Callback(hObject, eventdata, handles)
% hObject    handle to previewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
preview(handles.CurrentWebcam);


% --- Executes on button press in snaphotButton.
function snaphotButton_Callback(hObject, eventdata, handles)
% hObject    handle to snaphotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% shoots an image with the chosen camera and saves it with a suiting name
% in the specified folder.
image = snapshot(handles.CurrentWebcam);
%write the image as a png file and increment the running number to keep
%track how many images there are already
imwrite(image, strcat(handles.CurrentImageDirectory, '/img', sprintf('%03d', handles.currentImageNumber), '.png'));
imshow(image);
handles.currentImageNumber = handles.currentImageNumber + 1;
guidata(hObject, handles);


% --------------------------------------------------------------------
function MenuImageFolder_Callback(hObject, eventdata, handles)
% hObject    handle to MenuImageFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This function lets the user specify the folder in which images should be
% written
handles.CurrentImageDirectory = uigetdir();
guidata(hObject, handles);


% --- Executes on button press in saveCalibrationButton.
function saveCalibrationButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveCalibrationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This function takes a snapshot and saves it with the name for the
% calibration image in the specified folder.
image = snapshot(handles.CurrentWebcam);
imwrite(image, strcat(handles.CurrentImageDirectory, '/imgCalibration.png'));
imshow(image);
guidata(hObject, handles);
