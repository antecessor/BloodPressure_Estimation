function X=Znormal(X)

%MED=median(X');
%MAD=mad(X');
MAD=mad(X(:));
MED=median(X(:));
%for i=1:size(X,1)
%X(i,:)=(X(i,:)-MED(i))/MAD(i);
%end
X=(X-MED)/MAD;

end