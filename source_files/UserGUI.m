function varargout = UserGUI(varargin)
% USERGUI MATLAB code for UserGUI.fig
%      USERGUI, by itself, creates a new USERGUI or raises the existing
%      singleton*.
%
%      H = USERGUI returns the handle to a new USERGUI or the handle to
%      the existing singleton*.
%
%      USERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERGUI.M with the given input arguments.
%
%      USERGUI('Property','Value',...) creates a new USERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UserGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UserGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UserGUI

% Last Modified by GUIDE v2.5 28-Sep-2021 17:41:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UserGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @UserGUI_OutputFcn, ...
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


% --- Executes just before UserGUI is made visible.
function UserGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for UserGUI
handles.output = hObject;
handles.data_time = 0
handles.data_Ua = 0
handles.data_r = 4
handles.data_t_off = 0
handles.data_flag = 0
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = UserGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes when Ua edited
function edit_Ua_Callback(hObject, eventdata, handles)
data_Ua = str2double(get(hObject,'String'))
handles.data_Ua = data_Ua
set(handles.text_comment, 'string', '')
guidata(hObject, handles)


% --- Executes when time edited
function edit_time_Callback(hObject, eventdata, handles)
data_time = str2double(get(hObject,'String'))
handles.data_time = data_time
set(handles.text_comment, 'string', '')
guidata(hObject, handles)


% --- Executes when t_off edited
function edit_t_off_Callback(hObject, eventdata, handles)
data_t_off = str2double(get(hObject,'String'))
handles.data_t_off = data_t_off
set(handles.text_comment, 'string', '')
guidata(hObject, handles)


% --- Executes on button press in radiobutton_step_ua.
function radiobutton_step_ua_Callback(hObject, eventdata, handles)
set(handles.edit_time,'enable','off')
handles.data_flag = 0
set(handles.text_comment, 'string', '')
guidata(hObject, handles)


% --- Executes on button press in radiobutton_ramp_ua.
function radiobutton_ramp_ua_Callback(hObject, eventdata, handles)
set(handles.edit_time,'enable','on')
handles.data_flag = 1
set(handles.text_comment, 'string', '')
guidata(hObject, handles)


% --- Executes on button press in button_open_file.
function button_open_file_Callback(hObject, eventdata, handles)
% Init class
M1 = DC_motor()
M1 = M1.importData()
handles.M1_Ra = M1.Ra
handles.M1_J = M1.J
handles.M1_Mc = M1.Mc
handles.M1_La = M1.La
handles.M1_kFi = M1.kFi
guidata(hObject, handles)
if (M1.Ra >= 0)
    % Enable disabled obj
    set(handles.radiobutton_step_ua, 'enable', 'on')
    set(handles.radiobutton_ramp_ua, 'enable', 'on')
    set(handles.edit_Ua, 'enable', 'on')
    set(handles.edit_t_off, 'enable', 'on')
    set(handles.button_build_axes_Ua, 'enable', 'on')
    set(handles.button_start, 'enable', 'on')
    set(handles.text_comment, 'string', '???????? ????????? ?????????')
end


% --- Executes on button press in button_build_axes_Ua.
function button_build_axes_Ua_Callback(hObject, eventdata, handles)
if (handles.data_Ua <= 0)
    set(handles.text_comment, 'String', 'Ua ?? ????? ???? ?????? ??? ????? 0')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (isnan(handles.data_Ua))
    set(handles.text_comment, 'String', 'Ua ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (handles.data_t_off < 0)
    set(handles.text_comment, 'String', 'toff ?? ????? ???? ?????? 0')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (isnan(handles.data_t_off))
    set(handles.text_comment, 'String', 'toff ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (handles.data_flag == 0)
    calculate_axes_Ua_step(handles)
    set(handles.text_comment, 'String', '?????? ???????? ??????? ????????')
    set(handles.text_comment, 'ForegroundColor', 'black')
elseif (handles.data_time <= 0)
    set(handles.text_comment, 'String', 'time ?? ????? ???? ?????? ??? ????? 0')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (isnan(handles.data_time))
    set(handles.text_comment, 'String', 'time ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
else
    set(handles.text_comment, 'String', '?????? ???????? ??????? ????????')
    set(handles.text_comment, 'ForegroundColor', 'black')
    calculate_axes_Ua(handles)
end


% --- Executes on button press in button_start.
function button_start_Callback(hObject, eventdata, handles)
if (handles.data_Ua <= 0)
    set(handles.text_comment, 'String', 'Ua ?? ????? ???? ?????? ??? ????? 0')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (isnan(handles.data_Ua))
    set(handles.text_comment, 'String', 'Ua ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (handles.data_t_off < 0)
    set(handles.text_comment, 'String', 'toff ?? ????? ???? ?????? 0')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (isnan(handles.data_t_off))
    set(handles.text_comment, 'String', 'toff ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
elseif (handles.data_flag == 0)
    set(handles.text_comment, 'String', '?????? ???????? ??????? ????????')
    set(handles.text_comment, 'ForegroundColor', 'black')
    calculate_axes_Ua_step(handles)
    % Disable interactive obj
    set(handles.radiobutton_step_ua, 'enable', 'off')
    set(handles.radiobutton_ramp_ua, 'enable', 'off')
    set(handles.edit_Ua, 'enable', 'off')
    set(handles.edit_t_off, 'enable', 'off')    
    set(handles.button_build_axes_Ua, 'enable', 'off')
    set(handles.button_start, 'enable', 'off')
    set(handles.button_open_file, 'enable', 'off');
   % pause(1);
    tic
    calculate_axes_step(hObject, handles);
    toc
    % Enable disabled obj
    set(handles.radiobutton_step_ua, 'enable', 'on');
    set(handles.radiobutton_ramp_ua, 'enable', 'on');
    set(handles.edit_Ua, 'enable', 'on');
    set(handles.edit_t_off, 'enable', 'on');
    set(handles.button_build_axes_Ua, 'enable', 'on');
    set(handles.button_start, 'enable', 'on');
    set(handles.button_open_file, 'enable', 'on');
    set(handles.text_comment, 'string', '?????? ???? ? ???????? ????????');
elseif (handles.data_time <= 0)
    set(handles.text_comment, 'String', 'time ?? ????? ???? ?????? ??? ????? 0');
    set(handles.text_comment, 'ForegroundColor', 'red');
elseif (isnan(handles.data_time))
    set(handles.text_comment, 'String', 'time ?????? ???? ??????')
    set(handles.text_comment, 'ForegroundColor', 'red')
else
    set(handles.text_comment, 'String', '?????? ???????? ??????? ????????')
    set(handles.text_comment, 'ForegroundColor', 'black')
    calculate_axes_Ua(handles)
    % Disable interactive obj
    set(handles.edit_Ua, 'enable', 'off')
    set(handles.edit_time, 'enable', 'off')
    set(handles.edit_t_off, 'enable', 'off')
    set(handles.button_build_axes_Ua, 'enable', 'off')
    set(handles.button_start, 'enable', 'off')
    set(handles.button_open_file, 'enable', 'off')
    calculate_axes(hObject, handles)
    % Enable disabled obj
    set(handles.edit_Ua, 'enable', 'on')
    set(handles.edit_time, 'enable', 'on')
    set(handles.edit_t_off, 'enable', 'on')
    set(handles.button_build_axes_Ua, 'enable', 'on')
    set(handles.button_start, 'enable', 'on')
    set(handles.button_open_file, 'enable', 'on')
    set(handles.text_comment, 'string', '?????? ???? ? ???????? ????????')
end


% ------------------- Functions ------------------- %
% --- Calculates axes of speed and current (step)
function calculate_axes_step(hObject, handles)
% Clear axes
cla(handles.axes_speed)
cla(handles.axes_current)
% Init accuracy
acc = 100
% Init R
R = handles.M1_Ra + handles.data_r
% Init time properties
t0 = 0
if (handles.data_t_off >= 0.5)
    t_max = handles.data_t_off
else
    t_max = 0.5
end
t_final = t_max * 1.5
k_t = t_final / acc
tf = k_t
% Init Ua ramp properties
Ua_max = handles.data_Ua
% Init temp variables
temp_y1 = 0
temp_y2 = 0
for i = 1:acc
    tspan = [t0 tf];
    [t,y] = ode45(@(t,y) DC_motor_eq(y,Ua_max,R,handles.M1_kFi,handles.M1_La,handles.M1_Mc,handles.M1_J),tspan,[temp_y1 temp_y2]);
    temp_y1 = y(length(y(:,1)),1);
    temp_y2 = y(length(y(:,2)),2);
    t0 = t0 + k_t;
    tf = tf + k_t
    if (t0 >= handles.data_t_off)
        R = handles.M1_Ra
    end
    plot(handles.axes_speed,t,y(:,2),'-r')
    plot(handles.axes_current,t,y(:,1),'-r')
end
xlim(handles.axes_speed, [0 (t_max * 1.5)])
xlabel(handles.axes_speed, '?????, ?')
ylabel(handles.axes_speed, '????????, ???/?')
set(handles.axes_speed, 'xgrid', 'on')
set(handles.axes_speed, 'ygrid', 'on')
xlim(handles.axes_current, [0 (t_max * 1.5)])
xlabel(handles.axes_current, '?????, ?')
ylabel(handles.axes_current, '???, ?')
set(handles.axes_current, 'xgrid', 'on')
set(handles.axes_current, 'ygrid', 'on')


% --- Calculates axes of speed and current (ramp)
function calculate_axes(hObject, handles)
% Clear axes
% ??????? ???????? ?? ?????????? ????????
cla(handles.axes_speed)
cla(handles.axes_current)
% Init accuracy
% ????????????? ???????? (?????????? ??????, ??????? ???????? ?????????)
acc = 400
% Init R
% ????????????? ?????????? R
R = handles.M1_Ra + handles.data_r
% Init time properties
% ????????????? ?????????? ???????
t0 = 0
% ?????????? ???????????? ????? ?? ???? ???????
if (handles.data_time >= handles.data_t_off)
    t_max = handles.data_time
else
    t_max = handles.data_t_off
end
% ????? ????????????? ? 1,5 ???? ??? ??????????? ??????????? ????????
t_final = t_max * 1.5
k_t = t_final / acc
tf = k_t
% Init Ua ramp properties
% ????????????? ?????????? ??? ??????? ramp-???????
Ua_max = handles.data_Ua
n_Ua = handles.data_time / k_t
k_Ua = Ua_max / n_Ua
Ua = k_Ua
% Init temp variables
% ????????????? ?????????? ??? ????????????? ????????
temp_y1 = 0
temp_y2 = 0
% ???? ???????
for i = 1:acc
    % ????? ??????? ???????
    tspan = [t0 tf];
    % ?????? ??????? ???????????????? ?????????
    [t,y] = ode45(@(t,y) DC_motor_eq(y,Ua,R,handles.M1_kFi,handles.M1_La,handles.M1_Mc,handles.M1_J),tspan,[temp_y1 temp_y2]);
    % ?????? ?????????? ????? ??????? ?? ????????
    temp_y1 = y(length(y(:,1)),1)
    temp_y2 = y(length(y(:,2)),2)
    % ?????????? ?????? ?????????? ???????
    t0 = t0 + k_t
    tf = tf + k_t
    % ?????????? ????? Saturation
    if ((Ua < Ua_max))
    Ua = Ua + k_Ua
    end
    % ?????????? ??????????? ????????? ?? ?????????? ????????? ??????????
    % ???????
    if (t0 >= handles.data_t_off)
        R = handles.M1_Ra
    end
    % ????????? ???????
    plot(handles.axes_speed,t,y(:,2),'-r')
    plot(handles.axes_current,t,y(:,1),'-r')
end
% ????????? ????????
xlim(handles.axes_speed, [0 (t_max * 1.5)])
xlabel(handles.axes_speed, '?????, ?')
ylabel(handles.axes_speed, '????????, ???/?')
set(handles.axes_speed, 'xgrid', 'on')
set(handles.axes_speed, 'ygrid', 'on')
xlim(handles.axes_current, [0 (t_max * 1.5)])
xlabel(handles.axes_current, '?????, ?')
ylabel(handles.axes_current, '???, ?')
set(handles.axes_current, 'xgrid', 'on')
set(handles.axes_current, 'ygrid', 'on')


% --- Calculates axes_Ua (ramp)
function calculate_axes_Ua(handles)
x_interval = (handles.data_time * 1.5) / 100
x = 0:x_interval:(handles.data_time * 1.5)
k = handles.data_Ua / handles.data_time
for (i = 1:length(x))
    y(i) = k * x(i)
if (y(i) > handles.data_Ua)
    y(i) = handles.data_Ua
end
end
plot(handles.axes_Ua,x,y,'-r')
xlim(handles.axes_Ua, [0 (handles.data_time * 1.5)])
ylim(handles.axes_Ua, [0 (handles.data_Ua * 1.5)])
xlabel(handles.axes_Ua, '?????, ?')
ylabel(handles.axes_Ua, '?????????? ?? ?????, ?')
set(handles.axes_Ua, 'xgrid', 'on')
set(handles.axes_Ua, 'ygrid', 'on')


% --- Calculates axes_Ua (step)
function calculate_axes_Ua_step(handles)
y = [handles.data_Ua handles.data_Ua]
x = [0 1]
plot(handles.axes_Ua,x,y,'-r')
xlim(handles.axes_Ua, [0 1])
ylim(handles.axes_Ua, [0 (handles.data_Ua * 1.5)])
xlabel(handles.axes_Ua, '?????, ?')
ylabel(handles.axes_Ua, '?????????? ?? ?????, ?')
set(handles.axes_Ua, 'xgrid', 'on')
set(handles.axes_Ua, 'ygrid', 'on')
