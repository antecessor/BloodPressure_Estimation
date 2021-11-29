function newData=WorkWithCategoricalData(CategoricalIndex,X,Y)
  Data=X;
  
  for i=1:numel(CategoricalIndex)
    b = real(glmfit(X(:,CategoricalIndex(i)),(Y==1),'binomial','link','logit'));
    Data(CategoricalIndex(i),:) = glmval(b,X(CategoricalIndex(i),:),'logit');   
  end
  
newData=Data;
  
  

end