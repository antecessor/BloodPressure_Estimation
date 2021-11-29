function [Accuracy,Precison,Recall,FSCORE,Specificity] =calcmulti(test,m)
%% accuracy average
b=0;
for i=1:m
    a=(test(i).TP+test(i).TN)./(test(i).TP+test(i).TN+test(i).FP+test(i).FN);
b=b+a;
end
Accuracy=b/m;
%% precision  && Recall  && specificty
a=0;
b=0;
c=0;
d=0;
e=0;
for i=1:m
    a=test(i).TP+a;
    b=test(i).TP+test(i).FP+b;
    c=test(i).TP+test(i).FN+c;
    d=test(i).TN+test(i).FP+d;
    e=test(i).TN+e;
end
Precison=a./b;
Recall=a./c;
Specificity=e./d;

%% Fscore
FSCORE=2*Precison*Recall/(Precison+Recall);



end