function mfeacture = get2DFeactures(img_2D )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% SourcePic=imread('demo.jpg');  
  
% grayPic=rgb2gray(img_2D);  
% grayPic=im2double(grayPic1); 
% ����ʦ�ַָ��ͼ��ɫ�ϰ�ɫ����Ҫȥ�������Ӱ��
img_2D(find(img_2D>254))=0;

grayPic=img_2D;
[M,N]=size(grayPic);
% ������������������
% Sobel���� 
% H_V=edge(grayPic,'sobel',Threshold);  
% ������������������
% [VerticalSobel Threshold]=edge(grayPic,'sobel','vertical');%edge detect  
% [HorizontalSobel Threshold]=edge(grayPic,'sobel','horizontal');%edge detect  
% conv2
% ������������������
% HOG 
% [a b]=size(hog1)
%    subplot(1,2,1);
%    imshow(grayPic);
%    subplot(1,2,2);
%    plot(visualization);
% ������������������

% [hog1, visualization] = extractHOGFeatures(grayPic,'CellSize',[M/2 N/2]);


%��������һͼ������
kw_num=M*N-length(find(grayPic==0));  


      

kw_mean=0;
kw_var=0;
%ֱ��ͼƫб��   ��ʾĿ��ͼ������Ҷ�ƽ��ֵ��Χֱ��ͼ�ԳƵĳ̶�
%ֱ��ͼ���     Ŀ��ͼ��һάֱ��ͼ�����
kw_skewness=0;   %ƫб�� ���� ���ͼ�񲻶ԳƳ̶�
kw_kurtosis=0;   %���
kw_energy=0;
kw_ent=0; 


% ������������������
% һ��ֱ��ͼ����
% ������������������
kw_h=imhist(grayPic);

p1=(kw_h)/(kw_num); 
%һ��ֱ��ͼ�ľ�ֵ
kw_mean=sum(sum(grayPic))/kw_num;    

kw_skewness1=0;
kw_kurtosis1=0;
for i=2:256 % �Ҷ�Ϊ0��ȥ��
    if p1(i)~=0
      kw_var=kw_var+(i-kw_mean)*(i-kw_mean)*p1(i);
       kw_skewness1=kw_skewness1+((i-kw_mean)^3)*p1(i);
       kw_kurtosis1=kw_kurtosis1+((i-kw_mean)^4)*p1(i);
        kw_ent=-p1(i)*log(p1(i))+kw_ent;%һ��ֱ��ͼ��
        kw_energy=p1(i)*p1(i)+kw_energy;%����
    end
end

kw_skewness= kw_skewness1*kw_var^(-1.5); %ƫ̬
kw_kurtosis= kw_kurtosis1*kw_var^(-2) - 3;%��̬

% % ������������������������
% % ���ص���ֵ
% % ������������������������
% %ͬʱ�ҳ��Ҷ���ֵ
% kw_max=0;
% kw_min=0;
% 
% for i=2:256 % ignore�Ҷ�Ϊ0
%     if p1(i)~=0 
%       kw_min=i-1;
%       break;
%     end
% end
% 
% for i=256:2 % ignore�Ҷ�Ϊ0
%     if p1(i)~=0 
%       kw_max=i-1;
%       break;
%     end
% end



%�ܳ�
Y0=grayPic;
Y0(Y0>0)=1;
kw_c=sum(sum(bwperim(Y0)));

%���ܶ�  �ܳ���ƽ���������,��Ӧ�ֲڳ̶Ⱥ���״���ӳ̶�
kw_p=kw_c*kw_c/kw_num;

glcms = graycomatrix(grayPic);
glcmsfeature= graycoprops(glcms);

glrmfeatureVectortmp=getglrmfeature(grayPic);
glrmfeatureVector=glrmfeatureVectortmp(:)';

mfeacture=[glcmsfeature.Contrast ,glcmsfeature.Correlation,glcmsfeature.Energy,glcmsfeature.Homogeneity,kw_p,kw_c,kw_kurtosis,kw_skewness,kw_energy, glrmfeatureVector];
mfeacture(isnan(mfeacture))=0;

end

