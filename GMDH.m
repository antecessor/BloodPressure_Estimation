function [gmdh,L] = GMDH(params, X, Y)

    % This function was retrived from
    % navid rezaei (2021). GMDH (https://www.mathworks.com/matlabcentral/fileexchange/53249-gmdh), MATLAB Central File Exchange. Retrieved September 6, 2021.
    
    MaxLayerNeurons = params.MaxLayerNeurons;
    MaxLayers = params.MaxLayers;
    alpha = params.alpha;
    CategoricalIndex=params.CategoricalIndex;
    

    nData = size(X,2);

    %% Shuffle Data

    Permutation = randperm(nData);
    X = X(:,Permutation);
    Y = Y(:,Permutation);
    
    % Divide Data
    pTrainData = params.pTrain;
    nTrainData = round(pTrainData*nData);
    X1 = X(:,1:nTrainData);
    Y1 = Y(1:nTrainData);
    pTestData = 1-pTrainData;
    nTestData = nData - nTrainData;
    X2 = X(:,nTrainData+1:end);
    Y2 = Y(nTrainData+1:end);
    
    Layers = cell(MaxLayers, 1);

    Z1 = X1;
    Z2 = X2;
    
 
    for l = 1:MaxLayers

        L{l} = GetPolynomialLayer(Z1, Y1, Z2, Y2);
        
        ec = alpha*L{l}(1).error + (1-alpha)*L{l}(end).error;
        ec = max(ec, L{l}(1).error);
        L{l} = L{l}([L{l}.error] <= ec);

        if numel(L{l}) > MaxLayerNeurons
            L{l} = L{l}(1:MaxLayerNeurons);
        end

        if l==MaxLayers && numel(L{l})>1
            L{l} = L{l}(1);
        end

        Layers{l} = L{l};

        Z1 = reshape([L{l}.Y1hat],nTrainData,[])';
        Z2 = reshape([L{l}.Y2hat],nTestData,[])';
        pause(1)
        disp(['Layer ' num2str(l) ': Neurons = ' num2str(numel(L{l})) ', Min Error = ' num2str(L{l}(1).error)]);

        if numel(L{l})==1
            break;
        end

    end
   
    
    Layers = Layers(1:l);
    
    gmdh.Layers = Layers;

end