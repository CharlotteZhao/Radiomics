function p = seed_autochoose(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
close all;
cIM = imread('IMG-0001-00011.jpg');
m= rgb2gray(cIM);
figure, imshow(m, [0 200]), hold all
[nRow, nCol, nSli] = size(m);

 Flag=0;
P=[];
%����ͼ�߽��ҳ�ͷ��ͼ�ı�Ե�˵�
%�ҳ�ͼƬ�����һ������,40���Ҿ������Ժ�ĽϽӽ���ֵ
for i=1:nRow
    for j=1:nCol
        if(m(i,j,1)>40)
            point1=[i,j];
            Flag=1;
            break;
        end
    end
    if(Flag==1)
        break;
    end
end
%�ҳ�ͼƬ�����һ������
for i=nRow:-1:1
    for j=1:nCol
        if(m(i,j,1)>40)
            point2=[i,j];
            Flag=2;
            break;
        end
    end
    if(Flag==2)
        break;
    end
end
%�ҳ�ͼƬ��ߵ�һ������
for i=1:nCol
    for j=1:nRow
        if(m(j,i,1)>40)
            point3=[j,i];
            Flag=3;
            break;
        end
    end
    if(Flag==3)
        break;
      
    end
end
%�ҳ�ͼƬ�ұߵ�һ������
for i=nCol:-1:1
    for j=1:nRow
        if(m(j,i,1)>40)
            point4=[j,i];
            Flag=4;
            break;
        end
    end
    if(Flag==4)
        break;
    end
end

colWid=point2(1)-point1(1); %�����һ��������������ȥ�����һ�������������õ��п�
rowWid=point4(2)-point3(2); %�ұߵ�һ��������������ȥ��ߵ�һ�������������õ��п�
%����п�Ƚϴ���˵�����п���ͷ­�ĳ��ȣ��п���ͷ­���
if(abs(colWid)>abs(rowWid))
        %�����п��ǳ��ȣ���ôpiont3��point4��ͷ­ǰ�˵�ͺ�˵㣬ȡ�г����м��1/3��ΪĿ������Ŀ�
        widbegin=point3(2)+round(rowWid*0.33);
        widend=point3(2)+round(rowWid*0.66);
        %ȡpoint3��point4�е���������������1/3��������ΪĿ������ĳ�
        lenbegin=round((point3(1)+point4(1))/2);%ȡ�е��Ƿ�ֹpoint3��point4����һ��ֱ���ϣ���ȡ���ǵ��е㲿��
        lenend_tem1=lenbegin+round(colWid*0.33);
        lenend_tem2=lenbegin-round(colWid*0.33);
        %�ж������1/3���������ұ�1/3����������ǲ����ǲ���������ҪСһЩ
        if(sum(sum(m(lenbegin:lenend_tem1,widbegin:widend)),2)>sum(sum(m(lenend_tem2:lenbegin,widbegin:widend)),2))
            lenend=lenend_tem1;
        else
            lenend=lenbegin;
            lenbegin=lenend_tem2;
        end
        for i=lenbegin:lenend
        for  j=widbegin:widend
             P(end+1,:)=[i,j];
        end
        end
        %ȷ���������ͽ��ǲ����ǳ��������ⲿ��ͼ��س�����ΪͼƬ
        plot(P(:,2), P(:,1), 'LineWidth', 2);
        imwrite(m(lenbegin:lenend,widbegin:widend),'can.png');
        
        %һ�����õ��ķ���ʽһ���ģ�ֻ�������ж�ͼƬ�Ƿ������ŷţ����ŷţ������ҷ��˵����
else
        widbegin=point1(1)+round(colWid*0.33);
        widend=point1(1)+round(colWid*0.66);
        lenbegin=round((point1(2)+point2(2))/2);
        
        lenend_tem1=lenbegin+round(rowWid*0.33);
        lenend_tem2=lenbegin-round(rowWid*0.33);
    
        if(sum(sum(m(widbegin:widend,lenbegin:lenend_tem1)),2)>sum(sum(m(widbegin:widend,lenend_tem2:lenbegin)),2))
            lenend=lenend_tem1;
        else
            lenend=lenbegin;
            lenbegin=lenend_tem2;
            
        end
        for  i=widbegin:widend
             for j=lenbegin:lenend
            P(end+1,:)=[i,j];
        end
        end
         plot(P(:,2), P(:,1), 'LineWidth', 2);
         imwrite(m(widbegin:widend,lenbegin:lenend),'can.png');
end

      
end

