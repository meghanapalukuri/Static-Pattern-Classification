clc
clearvars
close all
% SPECIFY PATH of folder containing data in the variable fname
%% Loading data
% data_type='linearly_Separable_Data\group3';
% data_type='non-linearly_Separable\group3';
data_type='overlapping_data\group3';
Fname= 'C:\Meghana\Acads\9th sem\PR\Assignment 1\Questions\Dataset-1_2Dimensional\';
fname=cat(2,Fname,data_type);
cd(fname);
files = dir('*.txt'); 
N_class=length(files)/3;

for i=1:3:length(files) % Order is alphabetic
    Train_data=load(files(i+1).name,'-ascii');
    Validation_data=load(files(i+2).name,'-ascii');
    Test_data=load(files(i).name,'-ascii');
    if(i==1)
        Train=Train_data;
         Validation=Validation_data;
          Test=Test_data;
    else
    Train=horzcat(Train,Train_data);
     Validation=horzcat(Validation,Validation_data);
      Test=horzcat(Test,Test_data);
    end
end

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));

%% K-Nearest Neighbours

% Validation data - Finding optimal k: 
% [Opt_val,opt_k]=optimal_k(Train,Validation,N_class);

% Optimal values found using above function:
% opt_k=[1,1,1,1]; % For separable data
% opt_k=[8,8,14,29]; % For overlapping data
% opt_k=[14,14,14,14];
% for K=1:100
% opt_k=K*[1,1,1,1];
% % Validation data
% test_index=zeros(length(Validation),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=KNN_Classifier(Train,opt_k((i+1)/2),Validation(:,i:i+1),N_class);
% end
% Test data
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=KNN_Classifier(Train,opt_k((i+1)/2),Test(:,i:i+1),N_class);
% end
% Confusion matrix
% % figure(7)
% [ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(test_index,N_class);
% Comp_acc(K)=Perc_Class_Acc;
% K_val(K)=K;
% end
% plot(K_val,Comp_acc*100)
% xlabel('K value')
% ylabel('Classification Accuracy(%)')
% title('KNN Classifier performance')
% 
opt_k=15*[1,1,1,1];
% Test data
test_index=zeros(length(Test),N_class);
for i=1:2:(N_class*2)
test_index(:,(i+1)/2)=KNN_Classifier(Train,opt_k((i+1)/2),Test(:,i:i+1),N_class);
end
% Confusion matrix
% figure(7)
[ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(test_index,N_class);
print('KNN','-dpng')
%% Heuristic for Determination of each class' underlying distribution
% count=7;
% for i=1:N_class
%     figure(count)
%     title(cat(2,'CLASS',mat2cell(i)))
%     count=count+1;
% hist3(Train(:,2*i-1:2*i))
% end
%% Parameter estimation- Single normal distribution for each class
% MLE estimates: estimated as sample mean & sample covariances 
% Mean
% myu=zeros(1,N_class*2);
% for i=1:N_class
% myu(2*i-1:2*i)=mean(Train(:,2*i-1:2*i));
% end
% 
% % Covariance
% C=zeros(2,N_class*2);
% for i=1:N_class
% C(:,2*i-1:2*i)=cov(Train(:,2*i-1:2*i));
% end
% 
% % Normalized covariance (i.e same Covariance for all classes)
% C_norm=zeros(2,2);
% for i=1:N_class
% C_norm(1,1)=C_norm(1,1)+C(1,2*i-1)/N_class;
% C_norm(1,2)=C_norm(1,2)+C(1,2*i)/N_class;
% C_norm(2,1)=C_norm(1,2);
% C_norm(2,2)=C_norm(2,2)+C(2,2*i)/N_class;
% end
% % Uncorrelated covariance matrix, same for all classes
% C_uncorr(1,1)=C_norm(1,1);
% C_uncorr(2,2)=C_norm(2,2);
% 
% % Uncorrelated & same variance for all classes
% variance=(C_uncorr(1,1)+C_uncorr(2,2))/2;
% C_same_variance(1,1)=variance;
% C_same_variance(2,2)=variance;
% %% Naive-Bayes Classifier
% %% a. C_uncorr 
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=Naive_Bayes(Test(:,i:i+1),N_class,myu,C_same_variance);
% end
% 
% % Confusion matrix
% figure(8)
% [ConfMat_NBa,Class_Acc_NBa,Perc_ConfMat_NBa,Perc_Class_Acc_NBa]=CM(test_index,N_class);
% print('NBa','-dpng')
% %% b. C_norm 
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=Naive_Bayes(Test(:,i:i+1),N_class,myu,C_uncorr);
% end
% 
% % Confusion matrix
% figure(9)
% [ConfMat_NB,Class_Acc_NB,Perc_ConfMat_NB,Perc_Class_Acc_NB]=CM(test_index,N_class);
% print('NBb','-dpng')
% 
% %% c. C
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=Naive_Bayes(Test(:,i:i+1),N_class,myu,C);
% end
% 
% % Confusion matrix
% figure(10)
% [ConfMat_NBc,Class_Acc_NBc,Perc_ConfMat_NBc,Perc_Class_Acc_NBc]=CM(test_index,N_class);
% print('NBc','-dpng')
% 
% %% Bayes Classifier
% %% a. C_norm
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=Bayes(Test(:,i:i+1),N_class,myu,C_norm);
% end
% 
% % Confusion matrix
% figure(11)
% [ConfMat_B,Class_Acc_B,Perc_ConfMat_B,Perc_Class_Acc_B]=CM(test_index,N_class);
% print('Ba','-dpng')
% %% b. C
% test_index=zeros(length(Test),N_class);
% for i=1:2:(N_class*2)
% test_index(:,(i+1)/2)=Bayes(Test(:,i:i+1),N_class,myu,C);
% end
% 
% % Confusion matrix
% figure(12)
% [ConfMat_Bb,Class_Acc_Bb,Perc_ConfMat_Bb,Perc_Class_Acc_Bb]=CM(test_index,N_class);
% print('Bb','-dpng')
%% Decision region plots
% 
% % figure(1)
% % hold on;
% % for i=1:2:(N_class*2)
% % plot(Train(:,i),Train(:,i+1));
% % end
% % hold off;
% 
% y_bounds=[-16,21]; % Linearly separable
% x_bounds=[-14,19];
% % y_bounds=[-2,2]; % Non-Linearly separable
% % x_bounds=[-2,3];
y_bounds=[-11,15]; % Overlapping
x_bounds=[-10,12];
% 
% step=0.25/4; % Linearly separable.
step=0.25/4; % Overlapping
% % step=0.25/32; % Non-Linearly separable

count=1;
Dec_Reg=zeros((x_bounds(2)-x_bounds(1))/step,2);
for i=x_bounds(1):step:x_bounds(2)
    for j=y_bounds(1):step:y_bounds(2)
       Dec_Reg(count,1)=i;
       Dec_Reg(count,2)=j;
       count=count+1;
    end
end

type='KNN Classifier';
test_index_DR=KNN_Classifier(Train,1,Dec_Reg,N_class);
figure(1)
plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)

% type='Naive Bayes-a';
% test_index_DR=Naive_Bayes(Dec_Reg,N_class,myu,C_same_variance);
% figure(2)
% plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)
% 
% type='Naive Bayes-b';
% test_index_DR=Naive_Bayes(Dec_Reg,N_class,myu,C_uncorr);
% figure(3)
% plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)
% 
% type='Naive Bayes-c';
% test_index_DR=Naive_Bayes(Dec_Reg,N_class,myu,C);
% figure(4)
% plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)
% 
% type='Bayes-a';
% test_index_DR=Bayes(Dec_Reg,N_class,myu,C_norm);
% figure(5)
% plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)
% 
% type='Bayes-b';
% test_index_DR=Bayes(Dec_Reg,N_class,myu,C);
% figure(6)
% plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type)