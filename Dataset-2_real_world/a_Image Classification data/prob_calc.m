function p=prob_calc(Data,w,myu,Cov)
d=size(Data);
p=zeros(d(1),1);
for n=1:d(1)
    for q=1:length(w)
        Cov_q=Cov(:,:,q);
        p(n)=p(n)+w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
    end
end
% p(n)=log(p(n));
end