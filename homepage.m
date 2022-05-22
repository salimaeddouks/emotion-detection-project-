function varargout = homepage(varargin)
% HOMEPAGE MATLAB code for homepage.fig
%      HOMEPAGE, by itself, creates a new HOMEPAGE or raises the existing
%      singleton*.
%
%      H = HOMEPAGE returns the handle to a new HOMEPAGE or the handle to
%      the existing singleton*.
%
%      HOMEPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOMEPAGE.M with the given input arguments.
%
%      HOMEPAGE('Property','Value',...) creates a new HOMEPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before homepage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to homepage_OpeningFcn via varargin.
%*



%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help homepage

% Last Modified by GUIDE v2.5 15-May-2022 17:11:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @homepage_OpeningFcn, ...
                   'gui_OutputFcn',  @homepage_OutputFcn, ...
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


% --- Executes just before homepage is made visible.
function homepage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to homepage (see VARARGIN)

% Choose default command line output for homepage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes homepage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = homepage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
 varargout{1} = handles.output;


% --- Executes on button press in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clc
% clear all
% close all
% warning off;
cao=webcam;
  faceDetector=vision.CascadeObjectDetector;
 c=3;
 temp=0;
   while true
    e=cao.snapshot;
      bboxes =step(faceDetector,e);
    if(sum(sum(bboxes))~=0)
    if(temp>=c)
         break;
     else
     es=imcrop(e,bboxes(1,:));
      es=imresize(es,[227 227]);
     filename=strcat(num2str(temp),'.bmp');
     imwrite(es,filename);
     temp=temp+1;
      axes(handles.axes3);
      imshow(es);
      drawnow;
      end
    else
          axes(handles.axes3);
        imshow(e);
         drawnow;

    end
   end



% --- Executes on button press in Train.
function Train_Callback(hObject, eventdata, handles)
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% clc
% clear all
% close all
% warning off
g=alexnet;
layers=g.Layers;
layers(23)=fullyConnectedLayer(3);
layers(25)=classificationLayer;



allImages=imageDatastore('matlab1','IncludeSubfolders',true, 'LabelSource','foldernames');

opts=trainingOptions('sgdm','InitialLearnRate',0.001,'MaxEpochs',20,'MiniBatchSize',64);
Class=trainNetwork(allImages,layers,opts);
save Class;




% --- Executes on button press in pushbutton3.


% --- Executes on button press in test.


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % clc
% % clear all
% % close all
% % warning off;
% 
% 
% 
% 
load Class
cao=webcam;
faceDetector=vision.CascadeObjectDetector;
count=0;
while true && count<200
    e=cao.snapshot;
%     bboxes=step(faceDetector,e);
bboxes=faceDetector(e);
     if(sum(sum(bboxes))~=0)
    
%        
%           bboxes=  bboxes(1,:)
%     rectangle('Position',bboxes);
   es=imcrop(e,bboxes(1,:));
    es=imresize(es,[227 227]);
%      es=rgb2gray(es);
    label=classify(Class,es);
    
    a=char(label);
    figure
%      axes(handles.axes3);
    imshow(e),title(a);
%     Features = extractLBPFeatures(es);
%     PredictedClass=predict(Classifier,Features);
%     PredictedClass=char(PredictedClass);
%      imshow(e),title(PredictedClass);
    ax=gca;
    ax.TitleFontSizeMultiplier=1.5;
    pause(0.1);
    else
         axes(handles.axes3);
      imshow(e);
      ax=gca;
      title('Face Not Detected');
       ax.TitleFontSizeMultiplier=1.5;
       pause(0.1);
     end
    count=count+1;
end








% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
% imds1=imageDatastore('C:\Users\UEMF\Desktop\homepage\matlab1\sad','IncludeSubFolders',true,'LabelSource','foldernames');
% 
%   img = readimage(imds1,4);
% imshow(img)


% --- Executes on button press in trainImage.
function trainImage_Callback(hObject, eventdata, handles)
% hObject    handle to trainImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 imds=imageDatastore('pic','IncludeSubFolders',true,'LabelSource','foldernames');



  numClasses=3;
[imdsTrain,imdsTest] = splitEachLabel(imds,.8,'randomize');



options = trainingOptions("sgdm", ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.2, ...
    LearnRateDropPeriod=5, ...
    MaxEpochs=20, ...
    MiniBatchSize=64, ...
    Plots="training-progress")

layers = [
    imageInputLayer([255 255 3])
    convolution2dLayer(3,8,Padding="same")
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,16,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,32,Padding="same")
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

augmenter = imageDataAugmenter( ...
    'RandRotation',[0 360], ...
    'RandScale',[0.5 1])

  auimds=augmentedImageDatastore([255 255],imdsTrain,'DataAugmentation',augmenter);
  net1=trainNetwork(auimds,layers,options);
 save net1
   


% --- Executes on button press in testImage.
function testImage_Callback(hObject, eventdata, handles)
% clc
% clear all
% close all
% hObject    handle to testImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load net1.mat

%  augtestimds=augmentedImageDatastore([255,255],imds);
% % 
%  predicted_labels=classify(net,augtestimds);

a=getappdata(0,'a');



imResized=imresize(a,[255,255]);
[class,score]=classify(net1,imResized);
  axes(handles.axes2);
imshow(imResized)
title(['predClass=' char(string(class)),',','score=',num2str(max(score))])


% --- Executes on button press in dataImage.
function dataImage_Callback(hObject, eventdata, handles)
% hObject    handle to dataImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.*','pic');
filename=strcat(pathname,filename);
a=imread(filename);


axes(handles.axes1);
imshow(a);
setappdata(0,'a',a);
setappdata(0,'filename',a);
% handles.a=a;
% guidata(hObject,handles);


% --- Executes on button press in filtering.
function filtering_Callback(hObject, eventdata, handles)
% hObject    handle to filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes(handles.axes4);
a=getappdata(0,'a');
gs=im2gray(a);
H=fspecial('average',3);
gss=imfilter(gs,H);
axes(handles.axes5);

imshow(gss);

% --- Executes on button press in segmentation.
function segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a=getappdata(0,'a');

gs=im2gray(a);
gsAdj=imadjust(gs);
BW=imbinarize(gsAdj);
axes(handles.axes4);

imshow(BW);

% img=imread('3.jpg');
% Gray=rgb2gray(img);
%  bw=im2bw(Gray,.18);
% 
% 
% bw=imcomplement(bw);
% bw=imfill(bw,'holes');
% bw=bwareaopen(bw,500);
% str=strel('disk',11);
% bw=imerode(bw,str);
% 
%  img2=imread('up.jpg');
% % combine
% 
% R=img(:,:,1);
% G=img(:,:,2);
% B=img(:,:,3);
% 
% R2=img2(:,:,1);
% G2=img2(:,:,2);
% B2=img2(:,:,3);
% 
% R2(bw)=R(bw);
% G2(bw)=G(bw);
% B2(bw)=B(bw);
% 
% RGB=cat(3,R2,G2,B2);
% 
% %  axes(handles.axes4);
% figure
% imshow(RGB);


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
