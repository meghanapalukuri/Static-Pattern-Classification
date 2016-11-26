function plot_decision_region(test_index_DR,N_class,Train,Dec_Reg,y_bounds,x_bounds,type,h)

con1=1;
con2=1;
con3=1;
con4=1;
for i=1:length(test_index_DR)
if(test_index_DR(i)==1)
    Class_Dec_Reg(con1,1:2,1)=[Dec_Reg(i,1),Dec_Reg(i,2)];
    con1=con1+1;
elseif(test_index_DR(i)==2)
     Class_Dec_Reg(con2,1:2,2)=[Dec_Reg(i,1),Dec_Reg(i,2)];
   con2=con2+1;
elseif(test_index_DR(i)==3)
     Class_Dec_Reg(con3,1:2,3)=[Dec_Reg(i,1),Dec_Reg(i,2)];
   con3=con3+1;
elseif(test_index_DR(i)==4)
     Class_Dec_Reg(con4,1:2,4)=[Dec_Reg(i,1),Dec_Reg(i,2)];
   con4=con4+1;
end
end

s=1;
Colour(1,:)=s*[1 1 0];
Colour(2,:)=s*[1 0 1];
Colour(3,:)=s*[0 1 1];
Colour(4,:)=s*[0 1 0];

Name='Decision Regions: ';
nm=horzcat(Name,type);
hold on
title(nm)
xlabel('Dimension 1')
ylabel('Dimension 2')
xlim(x_bounds);
ylim(y_bounds);

for i=1:N_class
plot(Class_Dec_Reg(:,1,i),Class_Dec_Reg(:,2,i),'Color',Colour(i,:),'Marker','.','LineStyle','none')
end
if(N_class==4)
    leg1=legend('Class1','Class2','Class3','Class4');
elseif(N_class==2)
    leg1=legend('Class1','Class2');
end
    set(leg1,'Location','NorthOutside','Orientation','horizontal')

s=0.9;
Colours(1,:)=s*[1 1 0];
Colours(2,:)=s*[1 0 1];
Colours(3,:)=s*[0 1 1];
Colours(4,:)=s*[0 1 0];

for i=1:2:(N_class*2)
plot(Train(:,i),Train(:,i+1),'LineStyle','none','Color',Colours((i+1)/2,:),'Marker','o','MarkerFaceColor',Colours((i+1)/2,:));
end
hold off;
print(type,'-dpng','-r300')

end