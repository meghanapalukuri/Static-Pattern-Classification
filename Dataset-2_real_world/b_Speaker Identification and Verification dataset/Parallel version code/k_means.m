function [cluster_ind,N,myu]=k_means(k,Data)
dimensions=size(Data);
myu=zeros(k,dimensions(2));
Rand_ind=zeros(k,1);
Dist_vec=zeros(length(Data),k);
cluster_ind=zeros(length(Data),1);

% Assigning random means
for i=1:k
    Rand_ind(i)=randi(length(Data));
    myu(i,:)=Data(Rand_ind(i),:);
    cluster_ind(Rand_ind(i))=i;
end

count=0;
myu_old=zeros(k,dimensions(2));
while(sum(abs(myu-myu_old)>=10^(-4)*ones(k,dimensions(2))))
% Calculating distances
for j=1:length(Data)
    Data_j=Data(j,:);
        parfor i=1:k
            Dist_vec(j,i)=norm(myu(i,:)-Data_j);
        end
        [~,cluster_ind(j)]=min(Dist_vec(j,:));
end

% Recalculating means
sum_dat=zeros(k,dimensions(2));
N=zeros(k,1);
for j=1:length(Data)
    cluster_ind_j=cluster_ind(j); % Assigning to avoid overload during parallelization
    Data_j=Data(j,:);
    parfor i=1:k
        if(cluster_ind_j==i)
            sum_dat(i,:)=sum_dat(i,:)+Data_j;
            N(i)=N(i)+1;
        end
    end
end
myu_old=myu;
myu=zeros(k,dimensions(2));
parfor i=1:k
    myu(i,:)=sum_dat(i,:)/N(i);
end
count=count+1;
end
end