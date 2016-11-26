function p=prob_calc(Data,w,myu,Cov)
p=zeros(length(Data),1);
parfor n=1:length(Data)
    for q=1:length(w)
        Cov_q=Cov(:,:,q);
        p(n)=p(n)+w(q)*mvnpdf(Data(n,:),myu(q,:),Cov_q);
    end
end
end