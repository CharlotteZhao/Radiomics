clear
figure('DefaultAxesXTick',[],'DefaultAxesYTick',[],...
    'DefaultAxesFontSize',8,'Color','w')
%     X=readdicom('/Users/huangkaiwei/Documents/MATLAB/3drec/4/p/t',24);
%   X=readImg('/Users/huangkaiwei/Documents/MATLAB/3drec/4/adc',7);
% X=readImg('/Users/huangkaiwei/Documents/MATLAB/3drec/3/adc',7);
%  X=readdicom('/Users/huangkaiwei/Documents/MATLAB/3drec/2/q/t',19);%du

%read image
X=readImg('/Users/huangkaiwei/Documents/MATLAB/3drec/3/t',5);
X(find(X>253))=0;
% X=readdicom('/Users/huangkaiwei/Documents/MATLAB/3drec/2/q/t',19);
XR = X;
Ds = squeeze(XR);%ɾ��ֻ��һ�С�һ�е�ά��
% [x y z D] = reducevolume(D, [2 2 1]);%��4 4 1��ȡ������������

Ds = smooth3(Ds); % �����ݽ���ƽ������
map = pink(90);
% fv=isosurface(x,y,z,Ds, 5,'verbose');%�õ���ֵ�桢����
% p = patch(fv,'FaceColor', [1,.75,.65], 'EdgeColor', 'none'); %����ͼ����ɫ������
% p2 = patch(isocaps(x,y,z,Ds, 5), 'FaceColor', 'interp', 'EdgeColor','none');
hiso = patch(isosurface(Ds,5),'FaceColor',[1,.75,.65],'EdgeColor','none');
hcap = patch(isocaps(XR,5),'FaceColor','interp','EdgeColor','none');
view(215,30);  %ѡ����ά�ӽ�
axis tight; %��������������ݷ�Χһ��
daspect([1 1 .3])%���������᳤���֮��
colormap(gray(100)) %��ȡ��ǰɫͼ���ҶȲ��100��
camlight;%Ĭ�����Ϸ�������Դ
lighting gouraud  %�����Ȳ�ֵ����ƽ������
% isonormals(x,y,z,Ds,p);%�����ֵ���涥��ķ���
%---------
% XR = X;
% Ds = smooth3(XR);
% map = pink(90);
% hiso = patch(isosurface(Ds,5),'FaceColor',[1,.75,.65],'EdgeColor','none');
% hcap = patch(isocaps(XR,5),'FaceColor','interp','EdgeColor','none');
% colormap(map)
% daspect(gca,[1,1,.4])
% lightangle(305,30);
% fig = gcf;
% fig.Renderer = 'zbuffer';
% lighting gouraud  %�����Ȳ�ֵ����ƽ������
isonormals(Ds,hiso)
hcap.AmbientStrength = .6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;
ax = gca;
ax.View = [215,30];
ax.Box = 'On';

axis tight
title('�ָ�ı��ʰ�');
%  title('����������ά�ؽ�');