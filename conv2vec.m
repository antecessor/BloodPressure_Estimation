function R=conv2vec(x,m)
R=ones(size(x,1),m);
for i=1:size(x,1)
 if x(i)==1
  R(i,1)=2;
 elseif x(i)==2
   R(i,2)=2;  
 elseif x(i)==3
    R(i,3)=2;     
 elseif x(i)==4
   R(i,4)=2;         
 elseif x(i)==5
   R(i,5)=2;  
   elseif x(i)==6
   R(i,6)=2;  
   elseif x(i)==7
   R(i,7)=2;  
   elseif x(i)==8
   R(i,8)=2;  
   elseif x(i)==9
   R(i,9)=2;  
   elseif x(i)==10
   R(i,10)=2; 
   elseif x(i)==11
   R(i,11)=2;  
   elseif x(i)==12
   R(i,12)=2;  
   elseif x(i)==13
   R(i,13)=2;  
   elseif x(i)==14
   R(i,14)=2; 
   elseif x(i)==15
   R(i,15)=2;
   
 end
    
end

end