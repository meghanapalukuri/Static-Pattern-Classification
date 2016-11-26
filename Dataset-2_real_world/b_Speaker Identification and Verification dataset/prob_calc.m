function [p,tot_prob]=prob_calc(len,Data,w,myu,Cov)
p=zeros(length(Data),1);
tot_prob=zeros(length(len),1);

for n=1:length(Data)
    for q=1:length(w)
        Cov_q=Cov(:,:,q);
        p(n)=p(n)+w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
    end
end
N=0;
for k=1:length(len)
    for n=1:len(k)
tot_prob(k)=tot_prob(k)+log(p(n+N));
    end
    N=N+n;
   tot_prob(k)=tot_prob(k)/len(k);
end
end