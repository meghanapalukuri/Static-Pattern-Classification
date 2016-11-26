function [Opt_val,opt_k]=optimal_k(Train,Validation,N_class)
Opt_val=zeros(N_class,1);
opt_k=zeros(N_class,1);
k_start=length(Validation)-1;
for i=1:N_class
Class_Accuracy=zeros(length(Validation)-1,1);
for k=k_start:-1:1
    index=KNN_Classifier(Train,k,Validation(:,2*i-1:2*i),N_class);
    % Classification accuracy
    for j=1:length(index)
   if(index(j)==i)
       Class_Accuracy(k)=Class_Accuracy(k)+1;
   end
    end
end
[Opt_val(i),opt_k(i)]=max(Class_Accuracy);
% Finding minimum k value that gives same optimal classification
[S,ind]=sort(Class_Accuracy,'descend');
count=1;
for l=1:length(S)
    if(Opt_val(i)==S(l))
   Opt_K(count)=ind(l);
   count=count+1;
    else
        break;
    end
end
opt_k(i)=min(Opt_K);
Opt_val=Opt_val/length(Validation);

end