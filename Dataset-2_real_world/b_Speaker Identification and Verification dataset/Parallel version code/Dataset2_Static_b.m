clc
clearvars
close all
%% Loading all data
Fname= 'C:\Meghana\Acads\9th sem\PR\Assignment 1\Questions\Dataset-2_real_world\b_Speaker Identification and Verification dataset\Folders_team_wise\Team3\';
cd(Fname);
files = dir;
for i=3:length(files) % First 2 are . and .. for some reason
    Speaker_Names(i-2,:)=files(i).name;
end

N_speakers=length(Speaker_Names);
dim=39;
% For same no. of clusters for all classes
opt_k=5;
% W_NB=zeros(opt_k,N_speakers);
% MYU_NB=zeros(dim,opt_k,N_speakers);
% COV_NB=zeros(dim,dim,opt_k,N_speakers);
Toler_NB=10;

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
%%
% addAttachedFiles(gcp,'load_speaker_data.mat')
tic;
for sp_ind=1:N_speakers
Speaker=Speaker_Names(sp_ind,:);

Data=load_speaker_data('Train',Speaker,Fname);
% Data_val=load_speaker_data('Val',Speaker,Fname);
% 
% tmp = matlab.desktop.editor.getActive;
% cd(fileparts(tmp.Filename));

% Data_test=load_speaker_data('Test',Speaker,Fname);

%% Naive Bayes Classifier
% finding optimal clusters through training & checking with validation data
% k_total=10; % Vary from 1 to 10 at max
 
% Toler_NB=1;
% tic;
% [opt_k,Total_prob]=opt_clusters_GMM(k_total,Data,Data_val,Toler_NB);
% toc; % Took 2038s to run

% On optimizing, we get 10 clusters
% opt_k=10;

%% Initialization- Kmeans clustering Initialization
[cluster_ind,N1,myu1]=k_means(opt_k,Data); % Make sure N(q) ~=0

% Toler_NB=1;

% Iteration & Termination
[w_NB,myu_NB,Cov_NB]=GMM_Naive_Bayes(cluster_ind,N1,myu1,opt_k,Data,Toler_NB);

% save(Speaker,'w_NB','myu_NB','Cov_NB');
par_file=mat2str(sp_ind);
save(par_file,'w_NB','myu_NB','Cov_NB')
% W_NB(:,sp_ind)=w_NB;
% MYU_NB(:,:,sp_ind)=myu_NB;
% COV_NB(:,:,:,sp_ind)=Cov_NB;
end
toc;

%% Testing data
% class_ind=zeros(length(p_NB_test),2);
for sp_ind=1:N_speakers 
    % spk=sp_ind+2;
Speaker=Speaker_Names(sp_ind,:);
Data_test=load_speaker_data('Test',Speaker,Fname);
p_NB_test=zeros(length(Data_test),2,2); % Concatenate with previous prob matrix
for cl=1:2
p_NB_test(:,cl,sp_ind)=prob_calc(Data_test,W_NB(:,cl),MYU_NB(:,:,cl),COV_NB(:,:,:,cl));
end

%% % Concatenate with previous class_ind matrix
for i=1:length(p_NB_test)
if(p_NB_test(i,1,sp_ind)>p_NB_test(i,2,sp_ind))
    class_ind(i,sp_ind)=3;
else
    class_ind(i,sp_ind)=4;
end
end
end
%%
[ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(class_ind,2);
save('Test_params3_4.mat','Perc_Class_Acc','Perc_ConfMat','class_ind','p_NB_test')
%% Bayes Classifier
% Toler_B=100;
% 
% % Iteration & Termination
% [w_B,myu_B,Cov_B]=GMM_Bayes(cluster_ind,N1,myu1,k,Data,Toler_B);
% save(Speaker,'w_B','myu_B','Cov_B')
% 
% % Probability of points for the fitted GMM
% p_B_train=prob_calc(Data,w_B,myu_B,Cov_B);
% 
% % Probability of validation points for the fitted GMM
% p_B_val=prob_calc(Data_val,w_B,myu_B,Cov_B);
% 
% % Probability of test points for the fitted GMM
% p_B_test=prob_calc(Data_test,w_B,myu_B,Cov_B);