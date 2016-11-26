function [ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(test_index,N_class)
ConfMat=zeros(N_class,N_class);
Class_Acc=0;
for i=1:N_class
for j=1:length(test_index)
    for k=1:N_class
    if(test_index(j,i)==k)
        ConfMat(k,i)=ConfMat(k,i)+1;
    end
    end
end
Class_Acc=Class_Acc+ConfMat(i,i);
end
Perc_ConfMat=ConfMat/length(test_index);
Perc_Class_Acc=Class_Acc/(length(test_index)*N_class);
end