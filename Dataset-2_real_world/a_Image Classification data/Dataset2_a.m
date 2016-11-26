clc
clearvars
close all
%% Loading Data
fname= 'C:\Meghana\Acads\9th sem\PR\Assignment 1\Questions\Dataset-2_real_world\a_Image Classification data';
cd(fname);
load CompleteData.mat
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
%% 
% 1 15 9 10 7
    Data1=cell2mat(CompleteData(1,1));
    Data2=cell2mat(CompleteData(15,1));
    Data3=cell2mat(CompleteData(9,1));
    Data4=cell2mat(CompleteData(10,1));
    Data5=cell2mat(CompleteData(7,1));
    
%     Ind=[1 15 9 10 7];
% for i=1:5
%     Data1=cell2mat(CompleteData(Ind(i),1));
%     Data(1:length(Data1),:,i)=Data1;
% end
    % Do random selection instead
    
Train_Data1=Data1(1:round(0.7*length(Data1)),:);
Train_Data2=Data2(1:round(0.7*length(Data2)),:);
Train_Data3=Data3(1:round(0.7*length(Data3)),:);
Train_Data4=Data4(1:round(0.7*length(Data4)),:);
Train_Data5=Data5(1:round(0.7*length(Data5)),:);

Val_Data1=Data1(1+round(0.7*length(Data1)):round(0.85*length(Data1)),:);
Val_Data2=Data2(1+round(0.7*length(Data2)):round(0.85*length(Data2)),:);
Val_Data3=Data3(1+round(0.7*length(Data3)):round(0.85*length(Data3)),:);
Val_Data4=Data4(1+round(0.7*length(Data4)):round(0.85*length(Data4)),:);
Val_Data5=Data5(1+round(0.7*length(Data5)):round(0.85*length(Data5)),:);

Test_Data1=Data1(1+round(0.85*length(Data1)):length(Data1),:);
Test_Data2=Data2(1+round(0.85*length(Data2)):length(Data2),:);
Test_Data3=Data3(1+round(0.85*length(Data3)):length(Data3),:);
Test_Data4=Data4(1+round(0.85*length(Data4)):length(Data4),:);
Test_Data5=Data5(1+round(0.85*length(Data5)):length(Data5),:);

%% GMM
% Do not use k>=7
k=2; % Covariance matrix is not PD for k=20,22 sometimes,23-26; Works for 5,10,21
Toler_NB=10;
Toler_B=100;

for sp_ind=1:5 
    if(sp_ind==1)
    Data=Train_Data1;
    elseif(sp_ind==2)
    Data=Train_Data2;
    elseif(sp_ind==3)
    Data=Train_Data3;
    elseif(sp_ind==4)
    Data=Train_Data4;
    elseif(sp_ind==5)
    Data=Train_Data5;
    end
% Initialization
[cluster_ind,N1,myu1]=k_means(k,Data); % Make sure N(q) ~=0
% [cluster_ind,myu1] = kmeans(Data,k) ;
% N1=zeros(k,1);
% for j=1:length(Data)
%     for i=1:k
%         if(cluster_ind(j)==i)
%             N1(i)=N1(i)+1;
%         end
%     end
% end

% Iteration & Termination
% [w_NB,myu_NB,Cov_NB]=GMM_Naive_Bayes(cluster_ind,N1,myu1,k,Data,Toler_NB);
[w_B,myu_B,Cov_B]=GMM_Bayes(cluster_ind,N1,myu1,k,Data,Toler_NB);
% save(mat2str(sp_ind),'w_NB','myu_NB','Cov_NB')
save(Speaker,'w_B','myu_B','Cov_B')
sp_ind
end
%% Testing Bayes 
% GMModel = fitgmdist(Data,2)
% [w_B,myu_B,Cov_B]=GMM_Bayes(cluster_ind,N1,myu1,k,Data,Toler_B);
%% Probability of GMM
% load Data1.mat
% p=zeros(length(Data),1);
% for n=1:length(Data)
% for q=1:length(w)
%     Cov_q=Cov(:,:,q);
% p(n)=p(n)+w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
% end
% end
%% Testing data
for sp_ind=1:5
SP(sp_ind)=load(mat2str(sp_ind));
end

% class_ind=zeros(length(p_NB_test),2);
for sp_ind=1:5 
    if(sp_ind==1)
    Data_test=Test_Data1;
    elseif(sp_ind==2)
    Data_test=Test_Data2;
    elseif(sp_ind==3)
    Data_test=Test_Data3;
    elseif(sp_ind==4)
    Data_test=Test_Data4;
    elseif(sp_ind==5)
    Data_test=Test_Data5;
    end
    d=size(Data_test);
p_test=zeros(d(1),5,5); 

for cl=1:5
p_test(:,cl,sp_ind)=prob_calc(Data_test,SP(cl).w_NB,SP(cl).myu_NB,SP(cl).Cov_NB);
% p_test(:,cl,sp_ind)=prob_calc(Data_test,SP(cl).w_B,SP(cl).myu_B,SP(cl).Cov_B);
end

for i=1:length(p_test)
    [~,class_ind(i,sp_ind)]=max(p_test(i,:,sp_ind));
end
end

[ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(class_ind,5);
ConfMat=ConfMat';
save('Test_params.mat','Perc_Class_Acc','Perc_ConfMat','class_ind','p_test','ConfMat')