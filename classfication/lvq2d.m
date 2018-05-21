% img2dfea.mat  imgfea2Dt4 imgfea2Dt3 imgfea2Dt2 imgfea2Dt1;
%LVQ
clear al;
clc;

%%��������

%% LVQ������ķ��ࡪ�������������
%


%% ��������
load adcimg2dfea.mat;


x=[imgfea2Dt4; imgfea2Dt3 ;imgfea2Dt2 ;imgfea2Dt1];%t4 49; t3 53 ;t2 30; t1 38

featureMat=x;
 t1label= ones(1,38);
  t2label= ones(1,30).*2;
  t3label= ones(1,53).*3;
  t4label= ones(1,49).*4;
grp1 = [ t4label, t3label, t2label , t1label];
Train=featureMat';
Test1=[imgfea2Dt4; imgfea2Dt3 ;imgfea2Dt2 ;imgfea2Dt1];
Test=Test1';
testlabel =grp1;
% ѵ������
P_train=Train;
Tc_train=grp1;
T_train=ind2vec(Tc_train);
% ��������
P_test=Test;
Tc_test=testlabel;
%% ��������
count_1=length(find(Tc_train==1));
count_2=length(find(Tc_train==2));
totallen=length(find(Tc_train));
 count_3=length(find(Tc_train==3));
 count_4=length(find(Tc_train==4));
rate_1=count_1/totallen;
rate_2=count_2/totallen;
rate_3=count_3/totallen;
rate_4=count_4/totallen;
net=newlvq(minmax(P_train),80,[rate_1 rate_2 rate_3 rate_4],0.01,'learnlv2');
% �����������
net.trainParam.epochs=1000;
net.trainParam.show=10;
net.trainParam.lr=0.1;
net.trainParam.goal=0.1;
%% ѵ������
net=train(net,P_train,T_train);
%% �������
T_sim=sim(net,P_test);
Tc_sim=vec2ind(T_sim);
result=[Tc_sim;Tc_test]
%% �����ʾ%t4 28; t3 22;t2 26; t1 22
total_1=22;
total_2=26;
% total_3=length(find(totallabel==3));
% total_4=length(find(totallabel==4));
number_1=length(find(Tc_test==1));
number_2=length(find(Tc_test==2));
% number_3=length(find(Tc_test==3));
% number_4=length(find(Tc_test==4));
number_1_sim=length(find(Tc_sim==1 & Tc_test==1));
number_2_sim=length(find(Tc_sim==2 &Tc_test==2));
% number_3_sim=length(find(Tc_sim==3 & Tc_test==3));
% number_4_sim=length(find(Tc_sim==4 &Tc_test==4));
disp(['����������' num2str(24)...
      '  t1��' num2str(total_1)...
      '  t2��' num2str(total_2)]);
disp(['ѵ��������������' num2str(17)...
      '  t1��' num2str(count_1)...
      '  t2��' num2str(count_2)]);
disp(['���Լ�����������' num2str(7)...
      '  t1��' num2str(number_1)...
      '  t2��' num2str(number_2)]);
disp(['t1ȷ�' num2str(number_1_sim)...
      '  ���' num2str(number_1-number_1_sim)...
      '  ȷ����p1=' num2str(number_1_sim/number_1*100) '%']);
disp(['t2ȷ�' num2str(number_2_sim)...
      '  ���' num2str(number_2-number_2_sim)...
      '  ȷ����p2=' num2str(number_2_sim/number_2*100) '%']);
 

