function res = readdicom( input_path, cnt)
%UNTITLED Summary of this function goes here
% ������ȡdicom �����ļ���·��(ie /Users/huangkaiwei/Documents/MATLAB/test/)��ͼƬ������ͼƬ����Ϊ���ִ�һ����
if (nargin < 2)

    error(message('input arg error'));

end
% SB=strcat(str1,str2)
x=strcat(input_path,num2str(1));
res= dicomread(x);
for i=2:1:cnt
x=strcat(input_path,num2str(i));
d= dicomread(x);
res = cat(3,res,d);% ���������������ｫһ����ͼƬƴ�ӵ�D�У���Ϊ3ά����
i
end

end

