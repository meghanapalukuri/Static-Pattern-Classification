function [ConfMat,Class_Acc,Perc_ConfMat,Perc_Class_Acc]=CM(test_index,N_class)
ConfMat=zeros(N_class,N_class);
Class_Acc=0;
for i=1:N_class
for j=1:length(test_index)
    if(test_index(j,i)==1)
        ConfMat(1,i)=ConfMat(1,i)+1;
    elseif(test_index(j,i)==2)
        ConfMat(2,i)=ConfMat(2,i)+1;
    elseif(test_index(j,i)==3)
        ConfMat(3,i)=ConfMat(3,i)+1;
    elseif(test_index(j,i)==4)
        ConfMat(4,i)=ConfMat(4,i)+1;
    end
end
Class_Acc=Class_Acc+ConfMat(i,i);
end
Perc_ConfMat=ConfMat/length(test_index);
Perc_Class_Acc=Class_Acc/(length(test_index)*N_class);
end