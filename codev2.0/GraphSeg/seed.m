%先做阈值分割，然后取最可能是肿瘤的区域
close all;
clear all;
% add all needed function paths
addpath .\coherenceFilter
addpath .\GLtree3DMex
addpath .\DRLSE_v0
addpath F:\medicalmatlab\levelset_segmentation_biasCorrection_v1
addpath F:\360data\重要数据\桌面\newstory\mhmm\code\HMRF-EM-image_v2.1\HMRF-EM-image_v2.1\code
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
%end of Complie#
%load an gray image:
load clown;
Img=imread('cut_cancer_0.png');
if length(size(Img))>2
    Img=rgb2gray(Img);
end
I=Img(:,:,1); 

I_gray = I;

%smooth the image by coherence filter:
filted_I = CoherenceFilter(I_gray,struct('T',5,'rho',2,'Scheme','I', 'sigma', 1));
%k-nearest neighborhood model:
Lnn = graphSeg(filted_I, 0.5/sqrt(3), 10, 10, 1);
%display:
subplot(2, 1, 1), imshow(I_gray, []), title('original image');
subplot(2, 1, 2), imshow(label2rgb(Lnn)), title('k nearest neighborhood based segmentation');


%Img=dicomread('D:\MATLAB\work\NPC\21065721');   %读取图像
%metadata = dicominfo('D:\MATLAB\work\NPC\21065721');%存储信息
%imagesc(Img);%显示图像
%Img=imread('cut_cancer_0.png'); 
%Img = imread('123.jpg');
% Img=imread('cancer2.png'); 
% if length(size(Img))>2
%     Img=rgb2gray(Img);
% end
% I=Img(:,:,1); 
% figure;imshow(Img);colormap;

%% 确定最有可能的肿瘤区域
%%%%%%%%%%%%%%%%%%
[m n]=size(Img);
%% function based on location of Nasopharynx,PL

pl=zeros(m,n);
p2=zeros(m,n);
%a=295;b=400;c=285;d=500;
a=floor(m/4);b=3*a;c=floor(n/4);d=3*c;
pl(a:b,c:d)=1;
p2(a,c:d)=1;
p2(b,c:d)=1;
p2(a:b,c)=1;
p2(a:b,d)=1;


figure;
title('center ret');
imshow(pl);

%% function based on Tumor Imge Intensities PI
sum1=0;
lb=255;
ub=0;
pixel_sum=(b-a)*(d-c);
for i=a:b
    for j=c:d
       sum1=sum1+double(Img(i,j));
       if double(Img(i,j))<lb
           lb=double(Img(i,j));
       end 
       if double(Img(i,j))>ub
           ub=double(Img(i,j));
       end
    end
end
inavg=sum1/pixel_sum;%inavg该区域内图像灰度的平均值
%inavg=60;
%算的结果 下界：0  上界：194 取阈值T=195

eps=(ub-lb)/4;   
%eps=30/4;  %% 55`85
pi=3.1415926;
pI=zeros(m,n);
for i=a:b
    for j=c:d
      pI(i,j)=1-(exp((-(double(Img(i,j))-inavg)^2)/(2*(eps^2)))/(eps*((2*pi)^(1/2))))*50;%100
    end
end
%figure;
%title('equation2');
%imshow(pI);

%based on Non-Tumor Region,PN
pn=zeros(m,n);
level=graythresh(Img);
pn=im2bw(Img,level)-1;
%figure;
%title('equation3');
%imshow(pn,[]);

P=zeros(m,n);
%all
for i=1:m
    for j=1:n
      P(i,j)=0.5*((pl(i,j)+pI(i,j)+0.5*pn(i,j)));%
    end
end

%figure;
%title('all');
%imshow(P);

%% 多数决定少数 majority vote
Mask =(P>0.80);
Res = zeros(m*n,1);
for i =1:m
    for j = 1:n
        if Mask(i,j)==1
            label_tmp = Lnn(i,j);
            Res(label_tmp,1)= Res(label_tmp,1)+1;
        end
    end
    
end



[Y,I1] = max(Res)
Mask2 =(-1)*ones(m,n);
% Mask2 =zeros(m,n);
for i =1:m
    for j = 1:n
        if Lnn(i,j)==I1
           Mask2(i,j)=1;
        end
    end
    
end
% sum2=zeros(1,d);
% tmp=0;index=0;
% for i=c:d
%     for j=a:b
%        if double(P(j,i))>0.85
%            sum2(1,i)=sum2(1,i)+1;
%        end 
%     end
%     if sum2(1,i)>tmp
%         tmp=sum2(1,i);
%         index=i;
%     end
% end
% 
% tmp2=0;
% index_num=floor(tmp/2);
% seed_row=0;
% for i=a:b
%     if double(P(i,index))>0.85
%         tmp2=tmp2+1;
%     end
%     if tmp2==index_num
%         seed_row=i;
%     end
% end

figure;imshow(Img);colormap;
hold on;
contour(p2,'g');  %
figure;
spy(Mask);
figure;
spy(Mask2);



% hold on;
% plot(index,seed_row,'r')
% 
% 
% s=sprintf('最后种子点位置为:(%d,%d)\n',index,seed_row);
% text(index,seed_row,'*','color','red');
% disp(s);


%% levelset

% Img=imread('cut_cancer_0.png');
% Img=double(Img(:,:,1));
% A=255;
% Img_levelset=I_gray; % rescale the image intensities
% nu=0.001*A^2; % coefficient of arc length term
% 
% A=255;
% Img=A*normalize01(Img); % rescale the image intensities
% nu=0.001*A^2; % coefficient of arc length term
% 
% sigma = 4; % scale parameter that specifies the size of the neighborhood,高斯核函数参数
% iter_outer=50; 
% iter_inner=10;   % inner iteration for level set evolution
% 
% timestep=.1;
% mu=1;  % coefficient for distance regularization term (regularize the level set function)
% 
% c0=1;
% 
% figure(1);
% imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
% 
% % initialize level set function
% % initialLSF = c0*ones(size(Img));
% % initialLSF(90:200,150:250) = -c0;
% % u=initialLSF;
% u=Mask2;
% 
% 
% 
% hold on;
% contour(u,[0 0],'r');  %如果只想在高度i处画一条等高线， 使用countour(Z, [i i])。
% title('Initial contour');
% 
% 
% 
% figure(2);
% %将矩阵A中的元素数值按大小转化为不同颜色，并在坐标轴对应位置处以这种颜色染色
% imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal
% hold on;
% contour(u,[0 0],'r');
% title('Initial contour');
% 
% epsilon=1;
% b=ones(size(Img));  %%% initialize bias field
% 
% 
% %   H = FSPECIAL('gaussian',HSIZE,SIGMA) returns a rotationally
% %   symmetric Gaussian lowpass filter  of size HSIZE with standard
% %   deviation SIGMA (positive). HSIZE can be a vector specifying the
% %   number of rows and columns in H or a scalar, in which case H is a
% %   square matrix.
% %   The default HSIZE is [3 3], the default SIGMA is 0.5.
% K=fspecial('gaussian',round(2*sigma)*2+1,sigma); % Gaussian kernel
% KI=conv2(Img,K,'same'); %二维卷积
% KONE=conv2(ones(size(Img)),K,'same');
% 
% [row,col]=size(Img);
% N=row*col;
% 
% for n=1:iter_outer
%     [u, b, C]= lse_bfe(u,Img, b, K,KONE, nu,timestep,mu,epsilon, iter_inner);
% 
%     if mod(n,2)==0
%         pause(0.001);
%         imagesc(Img,[0, 255]); colormap(gray); axis off; axis equal;
%         hold on;
%         contour(u,[0 0],'r');
%         iterNum=[num2str(n), ' iterations'];
%         title(iterNum);
%         hold off;
%     end
%    
% end
% Mask =(Img>10);
% Img_corrected=normalize01(Mask.*Img./(b+(b==0)))*255;
% 
% figure(3); imagesc(b);  colormap(gray); axis off; axis equal;
% title('Bias field');
% 
% figure(4);
% imagesc(Img_corrected); colormap(gray); axis off; axis equal;
% title('Bias corrected image');
% 
% figure(5); imagesc(u);  colormap(gray); axis off; axis equal;
% title('contour u');

% %% another
% % 参数设置
% n_iter = 600;
% lambda1 = 1;
% lambda2 = 1;
% miu = 0.5*255*255;
% del_t = 1;
% v = 0;
% I = imread('cut_cancer_0.png'); % real miscroscope image of cells
% 
% 
% I=double(I(:,:,1));
% m = max(I(:)); n = min(I(:));
% I = uint8((I-n)*255/(m-n));  % convert uint16 to uint8
% figure, imshow(I)
% 
% mask = Mask2;
% hold on, contour(mask, 'g');
% Img = double(I);
% % 水平集函数
% % phi>0,框内；phi<0,框外
% phi = bwdist(1-mask) - bwdist(mask);
% phi = phi/max(phi(:)-min(phi(:))); % 归一化原因？
% % 做循环
% for n = 1:n_iter
%     c1 = sum(Img(phi>=0))/max(1,length(Img(phi>=0)));
%     c2 = sum(Img(phi<0))/max(1,length(Img(phi<0)));
%     [dx, dy] = gradient(phi);
%     grad_norm = max(eps,sqrt(dx.^2+dy.^2));
%     curvature = divergence(dx./grad_norm, dy./grad_norm);  % 求归一化后的曲率
%     delta_eps = 1/pi./(1+phi.^2);
%     speed = delta_eps.*(miu*curvature - v - lambda1*(Img-c1).^2 + lambda2*(Img-c2).^2);
%     speed = speed/sqrt(sum(sum(speed.^2)));
%     
%     phi = phi + del_t*speed;
% end
% region_mask = sign(phi);
% % region_mask = uint8(round(region_mask));
% % 
% % 
% figure, imshow(I), hold on, contour(region_mask, 'b');
% 
% 
% %% end

Img = imread('cut_cancer_0.png'); % real miscroscope image of cells
Img=double(Img(:,:,1));
%% parameter setting
timestep=5;  % time step
mu=0.2/timestep;  % coefficient of the distance regularization term R(phi)
iter_inner=5;
iter_outer=100;
lambda=105; % coefficient of the weighted length term L(phi)
alfa=1.5;  % coefficient of the weighted area term A(phi)
epsilon=1.5; % papramater that specifies the width of the DiracDelta function

sigma=1.5;     % scale parameter in Gaussian kernel
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution-
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

% initialize LSF as binary step function

phi=Mask2;

figure;
mesh(-phi);   % for a better view, the LSF is displayed upside down
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
title('Initial level set function');
view([-80 35]);

figure;
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
title('Initial zero level contour');
pause(0.5);

potential=2;  
if potential ==1
    potentialFunction = 'single-well';  % use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model 
elseif potential == 2
    potentialFunction = 'double-well';  % use double-well potential in Eq. (16), which is good for both edge and region based models
else
    potentialFunction = 'double-well';  % default choice of potential function
end


% start level set evolution
for n=1:iter_outer
    phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);
    if mod(n,2)==0
        figure(100);
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
    end
end

% refine the zero level contour by further level set evolution with alfa=0
alfa=0;
iter_refine = 10;
phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);

finalLSF=phi;
figure;
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
hold on;  contour(phi, [0,0], 'r');
str=['Final zero level contour, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
title(str);

pause(1);
figure;
mesh(-finalLSF); % for a better view, the LSF is displayed upside down
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
str=['Final level set function, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
title(str);
axis on;

figure;
resMask = phi>0;
spy(resMask)


%% level set end 

%% HMRF EM refine

mex BoundMirrorExpand.cpp;
mex BoundMirrorShrink.cpp;

I=imread('cut_cancer_0.png');
Y=rgb2gray(I);
Z = edge(Y,'canny',0.75);
Y=double(Y);
Y=gaussianBlur(Y,3);
figure;
imshow(uint8(Y),'blurred image.png');

EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic;
X= resMask;
[X, mu, sigma]=HMRF_EM(X,Y,Z,mu,sigma,k,EM_iter,MAP_iter);
figure;
imshow(uint8(X*120),'final labels.png');
toc;

