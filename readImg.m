function imgRes = readImg( input_path, cnt)
%UNTITLED Summary of this function goes here
% ������ȡdicom �����ļ���·��(ie /Users/huangkaiwei/Documents/MATLAB/t1/)��ͼƬ������ͼƬ����Ϊ���ִ�һ����
if (nargin < 2)

    error(message('input arg error'));

end
clear imgRes;


% SB=strcat(str1,str2)
% pre=strcat(input_path,'ggxC');
pre=input_path;
x=strcat(pre,num2str(1),'.jpg')
imgRes= imread(x);
for i=2:1:cnt
x=strcat(pre,num2str(i),'.jpg')
d= imread(x);
imgRes = cat(3,imgRes,d);% ���������������ｫһ����ͼƬƴ�ӵ�D�У���Ϊ3ά����
end

end

