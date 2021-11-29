function   [train,test]=calculate_info_theory(train_gold,test_gold,train_result,test_result)% 0 and 1s

test=[];train=[];

[train.Se,train.Sp,train.Acc,train.FalseAlarm,train.Betta,train.Alpha,train.Precision,train.Recall,train.Fscore,train.Power,train.AUC,train.MCC,train.DOR,train.DP]=calc_Se_Sp(train_gold,train_result);


[test.Se,test.Sp,test.Acc,test.FalseAlarm,test.Betta,test.Alpha,test.Precision,test.Recall,test.Fscore,test.Power,test.AUC,test.MCC,test.DOR,test.DP]=calc_Se_Sp(test_gold,test_result);

C = confusionmat(train_gold,train_result);

train.C=C;  %%ConfusionMatrix

if numel(C)>2
test.kappa=kappa_mara(C);
else
test.kappa=0;    
end

function [Se,Sp,Acc,FA,B,A,PR,RL,F,PW,AUC,MCC,DOR,DP]=calc_Se_Sp(gold,result)

if ((size(gold,1) ~=size(result,1)) & size(gold,1)==1)
    gold=gold';
elseif ((size(gold,1) ~=size(result,1)) & size(gold,2)==1)
    result=result';
end;

%% 1 means sickness : positive
K=0;
TP=length(find(gold==1+K & result==1+K));
TN=length(find(gold==K & result==K));

FP=length(find(gold==K & result==K+1));
FN=length(find(gold==K+1 & result==K));


Se=TP/(TP+FN); %=Recall=True Positive Rate
Sp=TN/(TN+FP); % =True Negative Rate
Acc=(TP+TN)/(TP+TN+FP+FN);
AUC=.5*(TP/(TP+FN)+TN/(TN+FP));
MCC=(TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
DOR=(TP/FP)/(FN/TN);

DP=(sqrt(3)/pi)*(log10(Se/(1-Se))+log10(Sp/(1-Sp)));%Discriminant Power



FA=FP/(FP+TN); % =False Alarm=False Positive Rate = 1-Sp
B=FN/(TP+FN); % Betta (False Negative RAte)=1-Se (Type II error)
A=FP/(FP+TN); % Alpha (False Positive Rate)=1-Sp=False Alarm (Type I error)
PR=TP/(TP+FP); % Precision 
RL=Se; % Recall
F=2*(PR*RL)/(PR+RL);
PW=Se; % =1-Betta

