function varargout = MeasureUtilityGUI(varargin)
% MEASUREUTILITYGUI MATLAB code for MeasureUtilityGUI.fig
%      MEASUREUTILITYGUI, by itself, creates a new MEASUREUTILITYGUI or raises the existing
%      singleton*.
%
%      H = MEASUREUTILITYGUI returns the handle to a new MEASUREUTILITYGUI or the handle to
%      the existing singleton*.
%
%      MEASUREUTILITYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASUREUTILITYGUI.M with the given input arguments.
%
%      MEASUREUTILITYGUI('Property','Value',...) creates a new MEASUREUTILITYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasureUtilityGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasureUtilityGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MeasureUtilityGUI

% Last Modified by GUIDE v2.5 19-Apr-2017 19:22:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasureUtilityGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasureUtilityGUI_OutputFcn, ...
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


% --- Executes just before MeasureUtilityGUI is made visible.
function MeasureUtilityGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MeasureUtilityGUI (see VARARGIN)

% Choose default command line output for MeasureUtilityGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MeasureUtilityGUI wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MeasureUtilityGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CalibrateExtrinsicsButton.
function CalibrateExtrinsicsButton_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrateExtrinsicsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CurrentlyProcessingRadio.Value = 1;
drawnow();
image = imread(strcat(handles.CurrentImageDirectory, '/imgCalibration.png'));
[R, t] = GetCameraExtrinsics(image, handles.CameraParams, 21.5);
handles.CameraRotation = R;
handles.CameraTranslation = t;
handles.CurrentlyProcessingRadio.Value = 0;
guidata(hObject, handles);

% --- Executes on button press in CalibrateColourButton.
function CalibrateColourButton_Callback(hObject, eventdata, handles)
% hObject    handle to CalibrateColourButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = imread(strcat(handles.CurrentImageDirectory, '/img000.png'));
figure;
imshow(image);
optimalLine = SelectPixelSpline(image);
close;
handles.CurrentlyProcessingRadio.Value = 1;
drawnow();
[handles.ColourThreshhold, diff] = FindOptimalThreshold(image, optimalLine, 'ycbcr');

maskYCbCr = MaskImageViaYCbCrThreshold(image, handles.ColourThreshhold);
extractedLineYCbCr = extractLineFromMaskedImage(maskYCbCr, image);
handles.OptimalBandwidth = FindOptimalBandwidth(image, optimalLine, extractedLineYCbCr, 0.1);

handles.ColourThreshholdText.String = ['Min Cr-Threshhold: ', num2str(handles.ColourThreshhold)];
handles.BandwidthText.String = ['Optimal Bandwidth: ', num2str(handles.OptimalBandwidth)];
handles.BestDifferenceText.String = ['Distance: ', num2str(diff)];
handles.CurrentlyProcessingRadio.Value = 0;
guidata(hObject, handles);


% --- Executes on button press in GeneratePointCloudButton.
function GeneratePointCloudButton_Callback(hObject, eventdata, handles)
% hObject    handle to GeneratePointCloudButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CurrentlyProcessingRadio.Value = 1;
drawnow();
handles.PointCloud = GetPointCloudFromImages(handles.CurrentImageDirectory, ...
                                             handles.ColourThreshhold, ...
                                             handles.CameraParams, ...
                                             handles.CameraRotation, ...
                                             handles.CameraTranslation, ...
                                             str2num(handles.ZOffsetEdit.String), ...
                                             handles.FitPixelLinesCheck.Value, ...
                                             handles.OptimalBandwidth);
PlotPointCloud(handles.PointCloud);
handles.PointCloud = handles.output;
handles.CurrentlyProcessingRadio.Value = 0;
guidata(hObject, handles);

% --------------------------------------------------------------------
function MenuImageDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to MenuImageDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CurrentImageDirectory = uigetdir();
handles.CurrentImageDirText.String = ['Current Image Dir: ', handles.CurrentImageDirectory];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ZOffsetEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZOffsetEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function MenuLoadCameraParams_Callback(hObject, eventdata, handles)
% hObject    handle to MenuLoadCameraParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraParamsPath = uigetfile();
handles.CameraParams = load(cameraParamsPath);
handles.CameraParams = handles.CameraParams.cameraParams;
handles.CurrentCameraParamsText.String = ['Current Camera Params: ', cameraParamsPath];
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
