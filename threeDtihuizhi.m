clear all
clc
D= imread('result3d25.jpg');
%ѭ����ȡͼƬ
for i=24:-1:1
fname = sprintf('result3d%d.jpg',i);
x=fname;
d= imread(x);
D = cat(3,D,d);% ���������������ｫһ����ͼƬƴ�ӵ�D�У���Ϊ3ά����
end
D = squeeze(D);%ɾ��ֻ��һ�С�һ�е�ά��
[x y z D] = reducevolume(D, [2 2 1]);%��4 4 1��ȡ������������
D = smooth3(D); % �����ݽ���ƽ������
fv=isosurface(x,y,z,D, 5,'verbose');%�õ���ֵ�桢����
p = patch(fv,'FaceColor', [1,.75,.65], 'EdgeColor', 'none'); %����ͼ����ɫ������
p2 = patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor','none');
view(0,90);  %Ĭ����ά�ӽ�
axis tight; %��������������ݷ�Χһ��
daspect([1 1 .3])%���������᳤���֮��
colormap(gray(100)) %��ȡ��ǰɫͼ���ҶȲ��100��
camlight;%Ĭ�����Ϸ�������Դ
lighting gouraud  %�����Ȳ�ֵ����ƽ������
isonormals(x,y,z,D,p);%�����ֵ���涥��ķ���
