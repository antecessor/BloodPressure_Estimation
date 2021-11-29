function [z,Output]=Cost(x,xtrain,ytrain,xtest,ytest)

    global NFE;
    if isempty(NFE)
        NFE=0;
    end

    NFE=NFE+1;

    X1 = CreateRegressorsMatrix(xtrain,x);
    X1=Check(X1);
    temp=X1*X1'+eye(size(X1*X1'));
    temp=Check(temp);
    
    c = ytrain*(pinv(temp)*X1)';
    Y1hat = c*(X1);
    Y1hat = min(max(Y1hat,0),1);
    
    X2 = CreateRegressorsMatrix(xtest,x);
    Y2hat = c*(X2);
    
    
%     [test.Accuracy,test.Precision,test.Se,test.FSCORE,test.Sp]=multiclassparam(round(ytest'),round(ytest'),round(Y2hat)',round(Y2hat)');
    Y1hat=real(Y1hat);
    Y2hat=real(Y2hat);
    [~,test]=calculate_info_theory(round(ytrain'),round(ytest'),round(Y1hat)',round(Y2hat)');% 0 and 1s
    test.MCC=Check(test.MCC);
    test.Sp=Check(test.Sp);
    test.Se=Check(test.Se);
     z=(1-(test.MCC*test.Se+test.Sp*test.Precision)/2);
   
    Output.test=test;
    Output.c=c;
end