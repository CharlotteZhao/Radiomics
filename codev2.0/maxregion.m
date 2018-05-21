clear,clc
I=imread('IMG-0001-00011.jpg');
% figure,imshow(I)
if length(size(I))>2
    I=rgb2gray(I);
end
bw=im2bw(I);
figure,
subplot(1,3,1),imshow(bw),title('ԭ����')
L = bwlabel(bw);
stats = regionprops(L);
Ar = cat(1, stats.Area);
ind = find(Ar ==max(Ar))
    I1=zeros(size(I));
    I1(L == ind) = 1;
    I(L == ind) = 0;

subplot(1,3,2), imshow(I1, []),title('�����������')
subplot(1,3,3),imshow(I, []),title('ȥ�������������')