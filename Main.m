clc
clear
close all
%% Load Data
Fs=125;
N_sampleProcess=500;  %4 sec
Number_Case_Wanted=1000;
load('Part_1.mat');
load('Part_2.mat');
% load('Part_3.mat');
% load('Part_4.mat');
% Seperate Signals & Remove Unreliable signals
[ECG{1},PPG{1},ABP{1},SBP{1},DBP{1}]=SperateSignals(Part_1,N_sampleProcess);
[ECG{2},PPG{2},ABP{2},SBP{2},DBP{2}]=SperateSignals(Part_2,N_sampleProcess);
% [ECG{3},PPG{3},ABP{3},SBP{3},DBP{3}]=SperateSignals(Part_3,N_sampleProcess);
% [ECG{4},PPG{4},ABP{4},SBP{4},DBP{4}]=SperateSignals(Part_4,N_sampleProcess);

%% Preprocessing
NCW=1;
for p=1:2
    for i=1:size(ECG{p},1) 
        DataECG=ECG{p}(i,:);
        DataPPG=PPG{p}(i,:);
        ECG_PPG = resample([DataECG;DataPPG]',8,1)';
        ECG_Den{p}(i,:)=DenoisingWavelet(ECG_PPG(1,:),1,1); %ECG
        PPG_Den{p}(i,:)=DenoisingWavelet(ECG_PPG(2,:),2,1); %PPG
        
           NCW=NCW+1;
           if (NCW>Number_Case_Wanted)
              break; 
           end
    end
end
%% ECG Processing and feature
RemoveNew=[];
NCW=1;
for p=1:2
    k=1;
     for i=1:size(ECG{p},1)
        try
%         [qrs_amp_raw{p,k},qrs_i_raw{p,k}]=pan_tompkin(ECG_Den{p}(i,:),Fs,1)
            [R_i{p,k},heart_rate{p,k}]=ECG_R_Dectect(ECG_Den{p}(i,:),Fs*8,0);
%           [R_i{p,k},R_amp{p,k},S_i{p,k},S_amp{p,k},T_i{p,k},T_amp{p,k},Q_i{p,k},Q_amp{p,k},heart_rate{p,k}]=peakdetect(ECG_Den{p}(i,:),Fs*8);
           FeaturePPG{p,k}=PPG_Processing(PPG_Den{p}(i,:),Fs*8,0);
         [Patd{p,k},Patf{p,k},Patp{p,k},AI{p,k},LASI{p,k},S1{p,k},S2{p,k},S3{p,k},S4{p,k},PPG_WholeFeature{p,k}]= FeatureExtraction(R_i{p,k},FeaturePPG{p,k},PPG_Den{p}(i,:));           
          NCW=NCW+1;
           if (NCW>Number_Case_Wanted)
              break; 
           end
        catch
           ECG{p}(i,:)=[];
           PPG{p}(i,:)=[];
           ABP{p}(i,:)=[];
           SBP{p}(i)=[];
           DBP{p}(i)=[];
           RemoveNew=[RemoveNew; p i]
        
           NCW=NCW+1;
           if (NCW>Number_Case_Wanted)
              break; 
           end
           continue; 
        end
        k=k+1;
    end
     if (NCW>Number_Case_Wanted)
              break; 
       end
end

%% ReadyData
[Data_ParameterBased,Data_WholeBased,TargetDBP,TargetSBP]=InputTarget_Ready(Patd,Patf,Patp,AI,LASI,S1,S2,S3,S4,heart_rate,PPG_WholeFeature,SBP,DBP,RemoveNew,Number_Case_Wanted);
%% DimentionReducion For WholeBase
n=50;  %% number reduction
WholeBaseFeature = pca(Data_WholeBased,n);
% WholeBaseFeature=score(:, 1:n);
%% Train Test
% TrainPercent=.7;
% IndexRand=randperm(size(Data_ParameterBased,1));
% TrainInd=IndexRand(1:round(numel(IndexRand)*TrainPercent));
% TestInd=IndexRand(round(numel(IndexRand)*TrainPercent)+1:end);
% 
% TrainData_ParameterBase=Data_ParameterBased(TrainInd,:);
% TestData_ParameterBase=Data_ParameterBased(TestInd,:);
% TrainTargetSBP=TargetSBP(TrainInd);
% TestTargetSBP=TargetSBP(TestInd);
% TrainTargetDBP=TargetDBP(TrainInd);
% TestTargetDBP=TargetDBP(TestInd);
% 
% TrainData_WholeBase=WholeBaseFeature(TrainInd,:);
% TestData_WholeBase=WholeBaseFeature(TestInd,:);

%% Regression
RegressionModels(Data_ParameterBased,TargetSBP,'SBP ParameterData')
RegressionModels(Data_ParameterBased,TargetDBP,'DBP ParameterData')
RegressionModels(WholeBaseFeature,TargetSBP,'SBP WholeData')
RegressionModels(WholeBaseFeature,TargetDBP,'DBP WholeData')
