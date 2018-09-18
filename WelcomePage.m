function varargout = WelcomePage(varargin)
% WELCOMEPAGE MATLAB code for WelcomePage.fig
%      WELCOMEPAGE, by itself, creates a new WELCOMEPAGE or raises the existing
%      singleton*.
%
%      H = WELCOMEPAGE returns the handle to a new WELCOMEPAGE or the handle to
%      the existing singleton*.
%
%      WELCOMEPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WELCOMEPAGE.M with the given input arguments.
%
%      WELCOMEPAGE('Property','Value',...) creates a new WELCOMEPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WelcomePage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WelcomePage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WelcomePage

% Last Modified by GUIDE v2.5 16-Jul-2018 21:35:51
global EROI;
global IN;
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WelcomePage_OpeningFcn, ...
                   'gui_OutputFcn',  @WelcomePage_OutputFcn, ...
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


% --- Executes just before WelcomePage is made visible.
function WelcomePage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WelcomePage (see VARARGIN)

% Choose default command line output for WelcomePage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WelcomePage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WelcomePage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 contents = get(handles.popupmenu1,'String'); %collecting the choice of the technology
 popupmenu1value = contents{get(handles.popupmenu1,'Value')};
 switch popupmenu1value % blocking one variable from being used depending on the technology 
  case 'Oil'
      set(handles.edit5,'string',0); % Technical Potential
      set(handles.edit6,'string',''); % Ultimate Recoverable Resource
  case 'Gas'
      set(handles.edit5,'string',0);
      set(handles.edit6,'string','');
  case 'Hydro'
     set(handles.edit5,'string',''); 
     set(handles.edit6,'string',0);
  case 'Solar PV'
     set(handles.edit5,'string',''); 
     set(handles.edit6,'string',0);
  case 'Wind'
     set(handles.edit5,'string',''); 
     set(handles.edit6,'string',0);
 end

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Declare the various parameters
 Gamma=1,Phi=1,chiWS=18,chiHO=0.001,chiG=6.653,EpsWS=25,EpsH=0.66,EpsG=1.409,EpsO=3.5;
 EkW=20,EkS=10,EkH=60,EkG=350,EkO=400;
%Get information as user inputs them 
 ST= str2double(get(handles.edit1,'string'));
 FT= str2double(get(handles.edit2,'string'));
 TP= str2double(get(handles.edit5,'string'));
 URR= str2double(get(handles.edit6,'string'));  
%Time interval 
 IT=FT-ST; 
%For any technology selected calculate values and plot
 contents = get(handles.popupmenu1,'String'); 
 popupmenu1value = contents{get(handles.popupmenu1,'Value')};
%Creating embty table for variable 
 PK=zeros(1,IT+1);
 G=zeros(1,IT+1);
 H=zeros(1,IT+1);
 EROI=zeros(1,IT+1);
 IN=ST:1:FT;
 %read Energy demand from EXCEL sheet
 E = xlsread('Energy.xlsx',1,'B2:B200');
 D=0;
 switch popupmenu1value
  case 'Oil'
      for t=1:1:IT+1
        D=D+E(t);  
        PK(t)=D/(URR);
        G(t)=1-(Gamma*exp(-EpsO*PK(t)));
        H(t)=Phi*exp(chiHO*PK(t));
        EROI(t)=EkO*G(t)*H(t);
        URR=URR-D;
      end
      
  case 'Gas'
      for t=1:1:IT+1
        D=D+E(t); 
        PK(t)=D/(URR);
        G(t)=1-(Gamma*exp(-EpsG*PK(t)));
        H(t)=Phi*exp(chiG*PK(t));
        EROI(t)=EkG*G(t)*H(t);
        URR=URR-D;
      end

  case 'Hydro'
      for t=1:1:IT+1
        PK(t)=E(t)/TP;
        G(t)=1-(Gamma*exp(-EpsH*PK(t)));
        H(t)=Phi*exp(chiHO*PK(t));
        EROI(t)=EkH*G(t)*H(t);
      end

  case 'Solar PV'
      for t=1:1:IT+1
        PK(t)=E(t)/TP;
        G(t)=1-(Gamma*exp(-EpsWS*PK(t)));
        H(t)=Phi*exp(chiWS*PK(t));
        EROI(t)=EkS*G(t)*H(t);
      end

  case 'Wind'
      for t=1:1:IT+1
        PK(t)=E(t)/TP;
        G(t)=1-(Gamma*exp(-EpsWS*PK(t)));
        H(t)=Phi*exp(chiWS*PK(t));
        EROI(t)=EkW*G(t)*H(t);
      end
 end
 %%%%%%Change location E:\personal documents\Nelson, input right location where the MATLAB file is saved%%%%%
 %%%% NB: If excel sheet Data isn't given path into the MATLAB folder then page 2 will not function%%%%%%%
  xlswrite('E:\personal documents\Nelson\MATLAB\Data.xlsx',IN,'Sheet1');
  xlswrite('E:\personal documents\Nelson\MATLAB\Data.xlsx',EROI,'Sheet2');
  xlswrite('E:\personal documents\Nelson\MATLAB\Data.xlsx',IT,'Sheet3');
  %Plot the different graphs
  plot(IN,G,'Parent',handles.axes1)
  plot(IN,EROI,'Parent',handles.axes2)
  plot(IN,H,'Parent',handles.axes3)
  xlim(handles.axes3,[ST,FT]);
  xlim(handles.axes2,[ST,FT]);
  xlim(handles.axes1,[ST,FT]);
 
 

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%open next page
Page1;
closePage1;
