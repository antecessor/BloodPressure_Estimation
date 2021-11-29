function [y1, y2]=ArithmeticCrossover(x1,x2,gamma,VarMin,VarMax)

    if nargin<3
        gamma=0;
    end

    alpha_min=-gamma;
    alpha_max=1+gamma;

    alpha=unifrnd(alpha_min,alpha_max,size(x1));
    
    y1=alpha.*x1+(1-alpha).*x2;
    y2=alpha.*x2+(1-alpha).*x1;

    % Clipping
    y1=max(y1,VarMin);
    y1=min(y1,VarMax);

    y2=max(y2,VarMin);
    y2=min(y2,VarMax);

end