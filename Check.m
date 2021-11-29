function temp=Check(temp)
[a,b]=find(temp==inf);
temp(a,b)=10e5;
 [a,b]=find(temp==-inf);
temp(a,b)=-10e5;
[a,b]=find(isnan(temp));
temp(a,b)=0;
end