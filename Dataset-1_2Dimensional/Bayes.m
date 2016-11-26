function ind=Bayes(Test,N_class,myu,C)
dim=size(C);
if(dim(2)==2)
    C=repmat(C,1,N_class);
end
ind=zeros(length(Test),1);
prob=zeros(length(Test),N_class);
for j=1:length(Test)
for i=1:N_class
    prob(j,i)=mvnpdf(Test(j,:),myu(2*i-1:2*i),C(:,2*i-1:2*i));
end
[~,ind(j)]=max(prob(j,:)); % Assuming priors are the same
end
end