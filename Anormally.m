function [NewData,NewTarget]=Anormally(Data,Target)
% every row is one sample
Tunique=unique(Target);
numberofGroup=numel(unique(Target));

for i=1:numberofGroup
    x{i}=Data(Target==Tunique(i),:);
end

n=size(Data);
m=cell(n);
s=cell(n);
N=zeros(n);
z=cell(n);
isnormal={};
alpha=1;
for i=1:numel(x)
    m{i}=mean(x{i});
    s{i}=0;
    N(i)=size(x{i},1);
    for j=1:size(x{i},1)
        s{i}=s{i}+(x{i}(j,:)-m{i})'*(x{i}(j,:)-m{i});
    end
    s{i}=s{i}/N(i)-1;
    for j=1:N(i)
        z{i}(j,:)=(x{i}(j,:)-m{i})* pinv(s{i})*(x{i}(j,:)-m{i})';
    end
    isnormal{i}=(z{i}<=alpha);
end

Y={};
for i=1:numel(isnormal)
   ind= isnormal{i}==1;
   x{i}(ind,:)=[]; 
   
   Y{i}=ones(size(x{i},1),1)*i;
   
end

NewData=cell2mat(x');
NewTarget=cell2mat(Y')-1;
end