function varargout = Page1(varargin)
% PAGE1 MATLAB code for Page1.fig
%      PAGE1, by itself, creates a new PAGE1 or raises the existing
%      singleton*.
%
%      H = PAGE1 returns the handle to a new PAGE1 or the handle to
%      the existing singleton*.
%
%      PAGE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAGE1.M with the given input arguments.
%
%      PAGE1('Property','Value',...) creates a new PAGE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Page1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Page1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Page1

% Last Modified by GUIDE v2.5 20-Jul-2018 00:38:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Page1_OpeningFcn, ...
                   'gui_OutputFcn',  @Page1_OutputFcn, ...
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


% --- Executes just before Page1 is made visible.
function Page1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Page1 (see VARARGIN)

% Choose default command line output for Page1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Page1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Page1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%Read data from Excel sheets
IN=xlsread('Data.xlsx',2,'A1:DA1');
EROI=xlsread('Data.xlsx',3,'A1:DA1');
IT=xlsread('Data.xlsx',4,'A1');
E=xlsread('Energy.xlsx',1,'B2:B200');
% Calculate the lenght of time (IN)
n=length(IN);
ST=IN(1);
FT=IN(IT+1);
%Create empty tables
ESCS=zeros(1,n);
aep=zeros(1,n);
escr=zeros(1,n);
aesc=zeros(1,n);
desc=zeros(1,n);
% assigning constances
ESCS(1)=1;
lesc=20;
cf=0.9;
%Calculate each variable
for t=1:1:n
    aep(t)=(ESCS(t)*EROI(t)/cf)/lesc;
    escr(t)=cf*lesc*E(t)/EROI(t);
    aesc(t)=max(escr(t)-ESCS(t),0);
    desc(t)=ESCS(t)/lesc;
    ESCS(t+1)=ESCS(t)+aesc(t)-desc(t);
end  
%Plot graph
plot(IN,aep,'Parent',handles.axes1);
plot(IN,ESCS(1:n),'Parent',handles.axes2);
plot(IN,aesc,'Parent',handles.axes3);
plot(IN,desc,'Parent',handles.axes4);
plot(IN,escr,'Parent',handles.axes5);
xlim(handles.axes1,[ST FT]);
xlim(handles.axes2,[ST,FT]);
xlim(handles.axes3,[ST,FT]);
xlim(handles.axes4,[ST,FT]);
xlim(handles.axes5,[ST,FT]);
  


 
