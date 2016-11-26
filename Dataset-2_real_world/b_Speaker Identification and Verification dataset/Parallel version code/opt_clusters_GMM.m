function [opt_k,Total_prob]=opt_clusters_GMM(k_total,Data,Data_val,Toler_NB)
Total_prob=zeros(k_total,1);
parfor k=1:k_total
%% Initialization- Kmeans clustering Initialization
[cluster_ind,N1,myu1]=k_means(k,Data); % Make sure N(q) ~=0
%% Naive Bayes Classifier

% Iteration & Termination
[w_NB,myu_NB,Cov_NB]=GMM_Naive_Bayes(cluster_ind,N1,myu1,k,Data,Toler_NB);

% Probability of points for the fitted GMM
% p_NB_train=prob_calc(Data,w_NB,myu_NB,Cov_NB);

% Probability of validation points for the fitted GMM
p_NB_val=prob_calc(Data_val,w_NB,myu_NB,Cov_NB);
Total_prob(k)=sum(log(p_NB_val)); % Overall log probability for a class
end
[~,opt_k]=max(Total_prob);
end