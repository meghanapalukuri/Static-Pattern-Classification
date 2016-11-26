clc
clearvars
close all
%% Loading data
Fname= 'C:\Meghana\Acads\9th sem\PR\Assignment 1\Questions\Dataset-2_real_world\b_Speaker Identification and Verification dataset\Folders_team_wise\Team3\';
cd(Fname);
files = dir;
for i=3:length(files) % First 2 are . and .. for some reason
    Speaker_Names(i-2,:)=files(i).name;
end

N_speakers=length(Speaker_Names);
dim=39;
% For same no. of clusters for all classes
opt_k=8;
% W_NB=zeros(opt_k,N_speakers);
% MYU_NB=zeros(dim,opt_k,N_speakers);
% COV_NB=zeros(dim,dim,opt_k,N_speakers);
Toler_NB=0.01;
Toler_B=0.1;

tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
%% Training data
tic;
for sp_ind=1:N_speakers
Speaker=Speaker_Names(sp_ind,:);

Data=load_speaker_data('Train',Speaker,Fname);
% Data_val=load_speaker_data('Val',Speaker,Fname);

%% Finding optimal no. of clusters for NB
% finding optimal clusters through training & checking with validation data
% k_total=10; % Vary from 1 to 10 at max
 
% tic;
% [opt_k,Total_prob]=opt_clusters_GMM(k_total,Data,Data_val,Toler_NB);
% toc; % Took 2038s to run

% On optimizing, we get 10 clusters
% opt_k=10;

%% Initialization- Kmeans clustering Initialization
[cluster_ind,N1,myu1]=k_means(opt_k,Data); % Make sure N(q) ~=0

%% Naive Bayes: Iteration & Termination
% [w_NB,myu_NB,Cov_NB]=GMM_Naive_Bayes(cluster_ind,N1,myu1,opt_k,Data,Toler_NB);

%% Bayes: Iteration & Termination

[w_B,myu_B,Cov_B]=GMM_Bayes(cluster_ind,N1,myu1,opt_k,Data,Toler_B);
%% Saving
% save(Speaker,'w_NB','myu_NB','Cov_NB')
save(Speaker,'w_B','myu_B','Cov_B')
% W_NB(:,sp_ind)=w_NB;
% MYU_NB(:,:,sp_ind)=myu_NB;
% COV_NB(:,:,:,sp_ind)=Cov_NB;
end
toc;
%% Loading GMM params

for sp_ind=1:N_speakers
% Speaker=Speaker_Names(sp_ind,:);
% SP(sp_ind)=load(Speaker);
SP(sp_ind)=load(mat2str(sp_ind));
end
%% Testing data
% class_ind=zeros(length(p_NB_test),2);
for sp_ind=1:N_speakers 
Speaker=Speaker_Names(sp_ind,:);
[Data_test,len]=load_speaker_data('Test',Speaker,Fname);
p_test=zeros(length(Data_test),N_speakers,N_speakers); 
tot_prob=zeros(N_speakers,N_speakers,N_speakers);
for cl=1:N_speakers
[p_test(:,cl,sp_ind),tot_prob(:,cl,sp_ind)]=prob_calc(len,Data_test,SP(cl).w_NB,SP(cl).myu_NB,SP(cl).Cov_NB);
% [p_test(:,cl,sp_ind),tot_prob(:,cl,sp_ind)]=prob_calc(len,Data_test,SP(cl).w_B,SP(cl).myu_B,SP(cl).Cov_B);
end

% for i=1:length(p_test)
%     [~,class_ind(i,sp_ind)]=max(p_test(i,:,sp_ind)); 
% end
for i=1:length(tot_prob)
    [~,class_ind(i,sp_ind)]=max(tot_prob(i,:,sp_ind)); 
end
end

[ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(class_ind,N_speakers);
%%
save('Test_params.mat','Perc_Class_Acc','Perc_ConfMat','class_ind','p_test')

