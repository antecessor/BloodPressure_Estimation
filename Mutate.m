function y=Mutate(x,mu,MutationMode,sigma,VarMin,VarMax)

    if nargin<3
        MutationMode='';
    end

	MutationMode=lower(MutationMode);
    
    nVar=numel(x);
    
    switch MutationMode
        case {'rand','random','stochastic'}
            A=(rand(size(x))<=mu);
            
        otherwise
            nmu=ceil(mu*nVar);
            j=randsample(nVar,nmu)';            
            A=zeros(size(x));
            A(j)=1;

    end

    J=find(A==1);

    y=x;
    y(J)=x(J)+sigma(J).*randn(size(J));

    % Clipping
    y=max(y,VarMin);
    y=min(y,VarMax);
    
end