function varargout = gui1(varargin)
% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
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


% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gui1 (see VARARGIN)
    
    % Choose default command line output for gui1
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    set(handles.axes1,'XColor', 'none','YColor','none');
    
    % UIWAIT makes gui1 wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
    % hObject    handle to load (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Open file selection dialog and filter for multiple image types
    [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tiff;*.gif', ...
                                      'Image Files (*.jpg, *.jpeg, *.png, *.bmp, *.tiff)'}, ...
                                     'Select an Image File');
    
    % Check if the user canceled the file selection
    if isequal(filename, 0)
        disp('User canceled file selection');
        return;
    end
    
    % Get the full file path
    fullFileName = fullfile(pathname, filename);
    
    % Supported file extensions
    supportedExtensions = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff'};
    
    % Get the file extension
    [~, ~, ext] = fileparts(fullFileName);
    
    % Check if the file extension is supported
    if ~ismember(lower(ext), supportedExtensions)
        errordlg('Unsupported file type. Please select a supported image file.', 'File Error');
        return;
    end
    
    % Try to read the image
    try
        img = imread(fullFileName);
    catch ME
        errordlg(['Error reading image file: ' ME.message], 'File Error');
        return;
    end
    
    % Display the image in the axes
    axes(handles.axes1);
    imshow(img);
    handles.axes1.UserData = img;
    
    % Update the handles structure
    guidata(hObject, handles);


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
    % hObject    handle to select (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Retrieve the image from handles
    img = handles.axes1.UserData;
    
    % Check if img is empty
    if isempty(img)
        errordlg('No image data found. Please load an image first.', 'Error');
        return;
    end

    % Open a new figure to select the crop area
    f1 = figure('Name', 'Select Crop Area', 'NumberTitle', 'off');
    imshow(img);

    % Use ginput to get two points from the user
    try
        [x, y] = ginput(2);
    catch ME
        if strcmp(ME.identifier, 'MATLAB:class:InvalidHandle')
            errordlg('Figure was closed before selection was made.', 'Selection Error');
        else
            rethrow(ME);
        end
        return;
    end
    
    % Close the figure used for selection
    close(f1);

    % Ensure the coordinates are valid and in the correct order
    x = sort(x);
    y = sort(y);

    % Check if the coordinates are within the image bounds
    if x(1) < 1 || y(1) < 1 || x(2) > size(img, 2) || y(2) > size(img, 1)
        errordlg('Selected area is out of image bounds. Please try again.', 'Selection Error');
        return;
    end

    % Perform the cropping operation
    imgCropped = imcrop(img, [x(1) y(1) x(2)-x(1) y(2)-y(1)]);
    
    % Display the cropped image
    axes(handles.axes1);
    imshow(imgCropped);

    % Update handles structure with the new cropped image
    handles.axes1.UserData = imgCropped;
    guidata(hObject, handles);


% --- Executes on button press in angling.
function angling_Callback(hObject, eventdata, handles)
    % hObject    handle to angling (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    img = handles.axes1.UserData;
    
    [rotated_img, angle] = rotate_barcode(img);
    
    % Display the padded image
    imshow(rotated_img, 'Parent', handles.axes1);
    handles.axes1.UserData = rotated_img;
    
    % Update the angle display
    % angle = abs(angle);
    set(handles.angle_text, 'String', strcat(num2str(angle), ' [deg]'));
    set(handles.angle_text, 'Visible', 'on');


% --- Executes on button press in read_barcode.
function read_barcode_Callback(hObject, eventdata, handles)
    % hObject    handle to read_barcode (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    img = handles.axes1.UserData;
    
    [barcode, found] = read_barcode(img);
    if found
        set(handles.barcode_text, 'String', erase(strjoin(string(barcode))," "));
        set(handles.barcode_text,'Visible','on');
        
    else
        set(handles.barcode_text, 'String', 'Barcode not found!');
        set(handles.barcode_text,'Visible','on');
    end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
    % hObject    handle to exit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    closereq();


% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
    % hObject    handle to restart (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Clear the text in barcode_text and angle_text
    set(handles.barcode_text, 'String', '');
    set(handles.angle_text, 'String', '');

    guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
