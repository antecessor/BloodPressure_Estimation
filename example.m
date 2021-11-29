%% Load Data
%Inputs : M*N  matrix, N:Number of sample , M:number of feature 
[Inputs, Targets] = cancer_dataset(); % loading the sample dataset
Targets=Targets(1,:);
 
%% Train Test 
Train_Ratio=.7; % The percentage of the training set
TrainPercent=Train_Ratio;
Label1_data=Inputs(:,Targets==0);
n1=size(Label1_data,2);
nTrain1=round(n1*TrainPercent);
IndexRandom=randperm(n1);
DataTrain1=Label1_data(:,IndexRandom(1:nTrain1));
IndTrain1=IndexRandom(1:nTrain1);
TargetTrain1=zeros(1,numel(1:nTrain1));
DataTest1=Label1_data(:,IndexRandom(nTrain1+1:end));
IndTest1=IndexRandom(nTrain1+1:end);
TargetTest1=zeros(1,numel(IndexRandom(nTrain1+1:end)));

Label2_data=Inputs(:,Targets==1);
n2=size(Label2_data,2);
nTrain2=round(n2*TrainPercent);
IndexRandom=randperm(n2);
DataTrain2=Label2_data(:,IndexRandom(1:nTrain2));
IndTrain2=IndexRandom(1:nTrain2);
TargetTrain2=ones(1,numel(1:nTrain2));
DataTest2=Label2_data(:,IndexRandom(nTrain2+1:end));
IndTest2=IndexRandom(nTrain2+1:end);
TargetTest2=ones(1,numel(IndexRandom(nTrain2+1:end)));

TrainInputs=[DataTrain1  DataTrain2];
TestInputs=[DataTest1  DataTest2];
TrainTargets=[TargetTrain1 TargetTrain2];
TestTargets=[TargetTest1 TargetTest2];
% Train Data Index
TrainInd = [IndTrain1 IndTrain2];
% Test Data Index
TestInd = [IndTest1 IndTest2];
%%
CategoricalIndex=[];
pTrain_pValidation=.7;  % the percentage of the estimation in the training set
isNormalize=true; % doing normalization
MaxLayerNeurons=15; % maximum neurons in each layer
MaxLayers=5;  % maximum layer
Selection_Pressure=.9; % Selection pressure
AnormallyF=false; % Outlier detection
NumberOfBestFeatureSelected=6; % Number of selected features
[gmdh,train,TrainOutputs,ranked,OutputsContinous_train]=FrameWork_Classification(TrainInputs,TrainTargets,CategoricalIndex,pTrain_pValidation,isNormalize,MaxLayerNeurons,MaxLayers,Selection_Pressure,AnormallyF,NumberOfBestFeatureSelected);
%% Test evaluation
%% Evaluate GMDH Network
TestInputs=WorkWithCategoricalData(CategoricalIndex,TestInputs,TestTargets);
if isNormalize==false
    for i=1:size(TestInputs,1)
        if ~ismember(i,CategoricalIndex)
         TestInputs(i,:)=Znormal(TestInputs(i,:));
        end
    end
end
TestData=TestInputs(ranked(1:NumberOfBestFeatureSelected),:);


OutputsContinous_test = ApplyGMDH(gmdh, TestData);
Outputs = double(OutputsContinous_test>=.5);
TestOutputs = Outputs;
[~,test]=calculate_info_theory(TestTargets,TestTargets,round(TestOutputs)',TestOutputs');% 0 and 1s
test

