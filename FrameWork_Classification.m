function [gmdh,train,TrainOutputs,ranked,OutputsContinous] =FrameWork_Classification(Inputs,Targets,CategoricalIndex,pTrain,isNormalize,MaxLayerNeurons,MaxLayers,Selection_Pressure,AnormallyF,NumberOfBestFeatureSelected)
% 2 classes framework
% example: 
% [Inputs, Targets] = cancer_dataset();
% Targets=Targets(1,:);
% CategoricalIndex=[]
% pTrain=.7;  
% isNormalize=false
% MaxLayerNeurons=10;
% MaxLayers=10;
% Selection_Pressure=.8;
% AnormallyF=false;
% NumberOfBestFeatureSelected=8;
% [gmdh,test,overAll,TrainOutputs,TestOutputs,ranked] =FrameWork_Classification(Inputs,Targets,CategoricalIndex,pTrain,isNormalize,MaxLayerNeurons,MaxLayers,Selection_Pressure,Train_Ratio,AnormallyF,NumberOfBestFeatureSelected)
% Inputs : M*N  matrix, N:Number of sample , M:number of feature 
%% Anormally 
if AnormallyF==true
[Inputs,Targets]=Anormally(Inputs',Targets);
Inputs=Inputs';
Targets=Targets';
end
%% convert Categorical to Interval
Inputs=WorkWithCategoricalData(CategoricalIndex,Inputs,Targets);
%% Normalization
if isNormalize==false
    for i=1:size(Inputs,1)
        if ~ismember(i,CategoricalIndex)
         Inputs(i,:)=Znormal(Inputs(i,:));
        end
    end
end
%% feature selection with relieff
%If you set K to 1, the estimates computed by relieff can be unreliable for noisy data. If you set K to a value comparable with the number of observations (rows) in X, relieff can fail to find important attributes. You can start with K = 10 and investigate the stability and reliability of relieff ranks and weights for various values of K.
k=10;
[ranked,~] = relieff(Inputs',Targets',k,'method','classification');
Inputs=Inputs(ranked(1:NumberOfBestFeatureSelected),:);



%% Create and Train GMDH Network

params.MaxLayerNeurons= MaxLayerNeurons;   % Maximum Number of Neurons in a Layer
params.MaxLayers = MaxLayers;          % Maximum Number of Layers
params.alpha = Selection_Pressure;            % Selection Pressure
params.pTrain = pTrain;   % Train Ratio
params.CategoricalIndex=CategoricalIndex;
[gmdh ,L] = GMDH(params, Inputs, Targets);


%% Evaluate GMDH Network
% 
OutputsContinous = ApplyGMDH(gmdh, Inputs);
Outputs = double(OutputsContinous>=.4);

TrainOutputs = Outputs;


% [test.Accuracy,test.Precison,test.Recall,test.FSCORE,test.Specificity]=multiclassparam(TrainTargets',TestTargets',round(TrainOutputs)',round(TestOutputs)');
train=calculate_info_theory(Targets,Targets,round(TrainOutputs)',round(TrainOutputs)');% 0 and 1s
train


end