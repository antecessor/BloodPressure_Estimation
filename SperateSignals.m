function [ECG,PPG,ABP,SBP,DBP]=SperateSignals(Data,N)

k=1;
for i=1:numel(Data)
    ECG(k,:)=Data{i}(3,end-N:end);
    PPG(k,:)=Data{i}(1,end-N:end);
    ABP(k,:)=Data{i}(2,end-N:end);
    [SBP(k),DBP(k)]=FindDBP_FindSBP(ABP(k,:));

    if isempty(SBP(k)) || isempty(DBP(k))
         k=k;
    else
         k=k+1;
    end
end
end