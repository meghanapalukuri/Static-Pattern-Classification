function class_index=KNN_Classifier(Train,k,Test,N_class)
%% Calculating distance
 dist=ones(length(Test),N_class*length(Train));
for i=1:length(Test) % Each test example
    ind=0;
    for class=1:N_class % Each class
        for j=1:length(Train) % Each training example of each class
           Dist_vector= Test(i,:)-Train(j,(2*class-1):(2*class));
            dist(i,ind+j)=norm(Dist_vector);
        end
        ind=ind+j;
    end
end
[~,I_sort]=sort(dist,2,'ascend'); 
class1_count=zeros(length(Test),1);
class2_count=zeros(length(Test),1);
class3_count=zeros(length(Test),1);
class4_count=zeros(length(Test),1);

parfor i=1:length(Test)
    for m=1:k
        if I_sort(i,m)<=length(Train)
            class1_count(i)=class1_count(i)+1;
        end
        if I_sort(i,m)>length(Train) && I_sort(i,m)<=2*length(Train)
            class2_count(i)=class2_count(i)+1;
        end
        if I_sort(i,m)>2*length(Train) && I_sort(i,m)<=3*length(Train)
            class3_count(i)=class3_count(i)+1;
        end
        if I_sort(i,m)>3*length(Train) && I_sort(i,m)<=4*length(Train)
            class4_count(i)=class4_count(i)+1;
        end
    end
end
    Class_count=[class1_count, class2_count, class3_count, class4_count];
    [~,I_majsort]=sort(Class_count,2,'descend');
    class_index=zeros(length(Test),1);
    parfor i=1:length(Test)
        if I_majsort(i,1)==1
            class_index(i)=1; end
        if I_majsort(i,1)==2
            class_index(i)=2; end
        if I_majsort(i,1)==3
            class_index(i)=3; end
        if I_majsort(i,1)==4
            class_index(i)=4; end
    end
end

