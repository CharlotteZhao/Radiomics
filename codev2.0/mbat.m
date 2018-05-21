%% ���������
close all;
clear all;
% add all needed function paths
addpath ./GraphSeg
addpath ./levelset_segmentation_biasCorrection_v1

% addpath F:\360data\��Ҫ����\����\26��MRI����\testdata\f
% addpath F:\360data\��Ҫ����\����\26��MRI����\oridata
% addpath F:\360data\��Ҫ����\����\26��MRI����\��֢
% addpath F:\360data\��Ҫ����\����\26��MRI����\��֢�ָ�\��֢
%% Compile
fprintf('COMPILING:\n')
mex GraphSeg_mex.cpp
fprintf('\tGraphSeg_mex.cpp: mex succesfully completed.\n') 

mex .\GLtree3DMex\BuildGLTree.cpp
fprintf('\tBuildGLTree : mex succesfully completed.\n') 

mex .\GLtree3DMex\KNNSearch.cpp
fprintf('\tKNNSearch : mex succesfully completed.\n') 

mex .\GLtree3DMex\DeleteGLTree.cpp
fprintf('\tDeleteGLTree : mex succesfully completed.\n\n') 

imageNamePath='F:\360data\��Ҫ����\����\26��MRI����\��֢\cancer';
cmpNamePath='F:\360data\��Ҫ����\����\26��MRI����\��֢�ָ�\��֢\cancer_result';

%% excel
excel = actxserver('excel.application'); % ��һ��excel��������
set(excel,'visible',2); % ʹexcel����ɼ�������excel���ڣ�

% ʵ��Ӧ��ʱ������Ϊ���ɼ�
workbooks = excel.workbooks; % ���������������
workbook = invoke(workbooks,'add'); % ���һ��������
sheets = excel.activeworkbook.sheets; % ��ȡ��ǰ��Ծ�������ı��飬һ������������������sheets��
sheet = get(sheets,'item',1); % ��ȡ�����һ����
invoke(sheet,'activate'); % ����ñ�

for i = 1:2
    imgIndex =sprintf('%d',i);
    if(i<10)
         imgIndex =sprintf('%s%d','0',i);
    end
imageName=sprintf('%s%s%s',imageNamePath,imgIndex,'.jpg');
saveImgName=sprintf('%s%s%s','F:\360data\��Ҫ����\����\newstory\mhmm\ref\zhao\����\segres\',imgIndex,'.jpg');
cmpName=sprintf('%s%s%s',cmpNamePath,imgIndex,'.jpg');

[CR ,PM, finalresMask, target]=NPC_segbat(imageName,cmpName);
CR_s=sprintf('%f',CR)
PM_s=sprintf('%d',PM)
figure,imshow(target,[]);

AIndex=sprintf('%s%d','a',i);
BIndex=sprintf('%s%d','b',i);
CIndex=sprintf('%s%d','c',i);
activesheet = excel.activesheet; % ��ȡ��ǰ��Ծ���ľ��
activesheetrange = get(activesheet,'range',AIndex); % ����д����Χ
set(activesheetrange,'value',imageName); % д������

activesheet = excel.activesheet; % ��ȡ��ǰ��Ծ���ľ��
activesheetrange = get(activesheet,'range',BIndex); % ����д����Χ
set(activesheetrange,'value',CR_s); % д������

activesheet = excel.activesheet; % ��ȡ��ǰ��Ծ���ľ��
activesheetrange = get(activesheet,'range',CIndex); % ����д����Χ
set(activesheetrange,'value',PM_s); % д������


 imwrite(target,saveImgName);

end
invoke(workbook,'saveas','res.xls'); % �����ļ�
