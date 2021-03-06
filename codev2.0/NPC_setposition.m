function [positionMat  adjustImg]=NPC_setposition(imgName)
%  fileName='D:\MATLABwork\NPC\';

% V = spm_vol_nifti('test1.nii');
% [Y,XYZ] = spm_read_vols(V);
% x1= Y(:,:,1);
% Img1=Y(:,:,30);
% Img1=double(Img1(:,:,1));

%  for i=20:30
%     ImgName=[fileName,'S4 (',num2str(i),')'];
%    Img0=imread('IMG-0001-00011.jpg');
%      Img0=dicomread(ImgName);   %读取图像
%      metadata = dicominfo(ImgName);%存储信息
     %imagesc(Img0);%显示图像
 %Img=dicomread('21065856.dcm');
 %Img=uint8(round(double(Img0)/65535 * 255));
Img0=imread(imgName);
Img=uint8(Img0);
%Img=uint8(round(Imgt*255));
%Img=imread('D:\MATLAB\work\NPC\s1.jpg'); 
%Img=imread('cancer2.png'); 
%Img=imread('cancer_0.png'); 
%Img=imread('cancer.bmp'); 
figure;
subplot(1, 2, 1); imshow(Img); title('Original Image');
I=Img;
if length(size(Img))>2
    I=rgb2gray(Img);
end
[m n]=size(I);

%---------------------------------调正图像--------------------------------------------------------
%  bw = im2bw(I, graythresh(I));
% [m0 n0]=size(bw);
% bw = edge(bw, 'canny');
% hold on;
% flag=0; 
% for j=1:n0
%     for i=1:m0
%         if bw(i,j)==1
%             p1=[i,j];
%             flag=1;
%             break;
%         end
%     end
%     if flag==1
%         break;
%     end
% end
% 
% flag=0;
% for j0=n0:-1:1
%     for i0=1:m0
%         if bw(i0,j0)==1
%             p2=[i0,j0];
%             flag=1;
%             break;
%         end
%     end
%     if flag==1
%         break;
%     end
% end
% 
% % plot([p1(2) p2(2)], [p1(1) p2(1)], 'r-o');
% k = (p2(1)-p1(1))/(p2(2)-p1(2));
% theta = atan(k)/pi*180;
% %I1(:, :, 1) = imrotate(I(:, :, 1), theta, 'bilinear');
% I1 = imrotate(I, theta, 'bilinear');
% %I1(:, :, 2) = imrotate(I(:, :, 2), theta, 'bilinear');
% %I1(:, :, 3) = imrotate(Img(:, :, 3), theta, 'bilinear');
% subplot(1, 2, 2); imshow(I1); title('Alignment Image');
% 
% %I2= rgb2gray(I1);
% [m1 n1]=size(I1);
% 
% %I0=I;
% %for i=1:m
% %    for j=1:n
%  %       I0(i,j)=I1(i+floor((m1-m)/2),j+floor((n1-n)/2));
%  %   end
% %end
% 
% figure;imshow(I1);colormap;
% [m1 n1]=size(I1);
I1=I;
adjustImg=I1;
[m1 n1]=size(I1);
%--------------------找耳线-----------------------
bw1 = im2bw(I1, graythresh(I1));
flag=0;
for j=1:n1
    for i=1:m1
        if bw1(i,j)==1
            s=[i,j];
            flag=1;
            break;
        end
    end
    if flag==1
        break;
    end
end
%------------------------------------------

%----------------------找最上面 和 最下面的点---------------------
flag=0;
for i=1:m1
    for j=1:n1
        if bw1(i,j)==1
            h=[i,j];
            flag=1;
            break;
        end
    end
    if flag==1
        break;
    end
end

flag=0;
for i=m1:-1:1
    for j=1:n1
        if bw1(i,j)==1
            l=[i,j];
            flag=1;
            break;
        end
    end
    if flag==1
        break;
    end
end

vertical_length=l(1)-h(1);
%-----------------------------------------------------------


%---------------------找最左边 最右边的点---------------------
flag=0; 
for j=1:n1
    for i=1:m1
        if bw1(i,j)==1
            l=[i,j];
            flag=1;
            break;
        end
    end
    if flag==1
        break;
    end
end

flag=0;
for j=n1:-1:1
    for i=1:m1
        if bw1(i,j)==1
            r=[i,j];
            flag=1;
            break;
        end
    end
    if flag==1
        break;
    end
end

horizontal_length=r(2)-l(2);

%---------------------------------------------------------------
 hold on;
%  for j=floor(s(1)-vertical_length/3):floor(s(1)-vertical_length/8)  %i=s(1)-80:s(1)-40
%     % for i=floor(n1/2-40):floor(n1/2+40)
%     for i=floor(l(2)+horizontal_length/3):floor(l(2)+horizontal_length*2/3)
%          %if j==floor(s(1)-vertical_length/3) || j==floor(s(1)-vertical_length/8) || i==floor(n1/2-40) || i==floor(n1/2+40)
%          if j==floor(s(1)-vertical_length/3) || j==floor(s(1)-vertical_length/8) ||i==floor(l(2)+horizontal_length/3)||i==floor(l(2)+horizontal_length*2/3)
%           plot(i,j,'.','MarkerEdgeColor','b','MarkerSize',2);
%          end
%      end
%  end
%  plot(m1/2,n1/2,'.','MarkerEdgeColor','r','MarkerSize',16);
 
 %range of row
%   a=floor(l(2)+horizontal_length/4);
%  b=floor(l(2)+horizontal_length*2/3);
 a=floor(l(2)+horizontal_length/4);
 b=floor(l(2)+horizontal_length*3/4);
 %range of col
%   c=floor(s(1)-(4*vertical_length)/12);
 c=floor(s(1)-vertical_length/3-20);
 d=floor(s(1)-vertical_length/8+20);

%   d=floor(s(1));
%  c=floor(s(1)-vertical_length/3+50);
%   d=floor(s(1)-vertical_length/8+10);
%  d=floor(s(1)-vertical_length/20);
    plot([a a],[c d],'-r');
     plot([b b],[c d],'-r');
       plot([a b],[c c],'-r');
     plot([a b],[d d],'-r');

 
positionMat=[a b c d];

 s=sprintf('定位区域为:[%d：%d] [%d：%d]\n',a,b,c,d);
 disp(s);
% end
 %-----------------------------我是华丽丽的分界线-------------------------------------------