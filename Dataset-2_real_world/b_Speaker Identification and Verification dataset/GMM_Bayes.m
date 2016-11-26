function [w,myu,Cov]=GMM_Bayes(cluster_ind,N1,myu1,k,Data,Toler)
dimensions=size(Data);
gamma1=zeros(length(cluster_ind),k);
for j=1:length(cluster_ind)
    for i=1:k
        if(i~=cluster_ind(j))
            gamma1(j,i)=0;
        else
            gamma1(j,i)=1;
        end
    end
end

w1=zeros(k,1);
for q=1:k
    w1(q)=N1(q)/sum(N1);
end

Cov1=zeros(dimensions(2),dimensions(2),k);

count=ones(k,1);
for j=1:length(cluster_ind)
    for q=1:k
        if(cluster_ind(j)==q)
            Cluster_Data(count(q),:,q)=(Data(j,:));
            Mean_scaled_Cluster_Data(count(q),:,q)=Cluster_Data(count(q),:,q)-myu1(q,:);
            count(q)=count(q)+1;
            %   Cov1(:,:,q)=Cov1(:,:,q)+(Data(j,:)-myu1(q,:))'*(Data(j,:)-myu1(q,:));
        end
    end
    %  Cov1(:,:,q)=Cov1(:,:,q)/N1(q); % Does not work. Checked for k=5 &
    %  own kmeans function
end


for q=1:k
    Cov1(:,:,q)=cov(Mean_scaled_Cluster_Data(1:N1(q),:,q));
end

% Calculating likelihood
term1=0;
L1=0;
for n=1:length(cluster_ind)
    for q=1:k
        Cov_q=Cov1(:,:,q);
        % [~,err(n,q)] = cholcov(Cov_q,0);
        term1= term1+ w1(q)*mvnpdf(Data(n,:),myu1(q,:),Cov_q);
    end
    L1= L1+ log(term1);
end

% gamma=gamma1;
Lold=0;
L=L1;
Cov=Cov1;
myu=myu1;
w=w1;
% N=N1;

gamma=zeros(length(cluster_ind),k);
    for n=1:length(cluster_ind)
        gamsum=0;
        for q=1:k
            Cov_q=Cov(:,:,q);
            gamma(n,q)=w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
            gamsum= gamsum+ gamma(n,q);
        end
        gamma(n,:)=gamma(n,:)/gamsum;
    end
    
%% Iterations
counter=0;

 while(abs(L-Lold)>Toler)
counter=counter+1;
% for i=1:5
    gamma=zeros(length(cluster_ind),k);
    for n=1:length(cluster_ind)
        gamsum=0;
        for q=1:k
            Cov_q=Cov(:,:,q);
            gamma(n,q)=w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
            gamsum= gamsum+ gamma(n,q);
        end
        gamma(n,:)=gamma(n,:)/gamsum;
    end
    N=zeros(k,1);
    myu=zeros(k,dimensions(2));
    for q=1:k
        for n=1:sum(N1)
            myu(q,:)=myu(q,:)+gamma(n,q)*Data(n,:);
            N(q)= N(q)+gamma(n,q);
        end
        myu(q,:)=myu(q,:)/N(q);
    end
    
    Cov=zeros(dimensions(2),dimensions(2),k);
    
    w=zeros(k,1);
    for q=1:k
        for n=1:sum(N1)
            Cov(:,:,q)= Cov(:,:,q)+gamma(n,q)*(Data(n,:)-myu(q,:))'*(Data(n,:)-myu(q,:));
        end
        w(q)=N(q)/sum(N);
        Cov(:,:,q)= Cov(:,:,q)/N(q);
    end
    
    % Calculating likelihood
    term=0;
    Lold=L;
    L=0;
    for n=1:length(cluster_ind)
        for q=1:k
            Cov_q=Cov(:,:,q);
            % [~,err(n,q)] = cholcov(Cov_q,0);
            term= term+ w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
        end
        L= L+ log(term);
    end
    
   % abs(L-Lold)
 end
end