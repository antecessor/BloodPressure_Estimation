function [Patd,Patf,Patp,AI,LASI,S1,S2,S3,S4,PPG_WholeFeature]=FeatureExtraction(R,PPGF,PPG)
Mean_F=PPGF.Mean_F;
Systolic=PPGF.Systolic;
Systolic_End=PPGF.Systolic_End;
DiastolicInd=PPGF.Diastolic;
InfectionInd=PPGF.Infection;
%% PAT
for i=1:numel(R)
   R_SYSEND=Systolic_End-R(i);
   R_SYSEND(R_SYSEND<0)=inf;
   Patf(i)=min(R_SYSEND);
   
   R_SYS=Systolic-R(i);
   R_SYS(R_SYS<0)=inf;
   Patp(i)=min(R_SYS);
   
   R_F=Mean_F-R(i);
   R_F(R_F<0)=inf;
   Patd(i)=min(R_F);
   
end

Patp=median(Patp);
Patd=median(Patd);
Patf=median(Patf);
%% AI
N=min([numel(InfectionInd) numel(Systolic_End) numel(Systolic)]);
x=abs(PPG(Systolic_End(1:N))-PPG(InfectionInd(1:N)));
y=abs(PPG(Systolic_End(1:N))-PPG(Systolic(1:N)));
AI=median(x./y);
%% LASI
LASI=median(abs(InfectionInd-Systolic(1:numel(InfectionInd))));
%% IPA
% s1 & s2
for i=1:numel(Systolic_End)
   X=Systolic_End(i):Mean_F(i);
   S1(i) = abs(trapz(X,PPG(X)));
   X=Mean_F(i):Systolic(i);
   S2(i) = abs(trapz(X,PPG(X)));
end
S1=median(S1);
S2=median(S2);
% s3
newSubset1=[Systolic(1:end-1) InfectionInd(1:end)];
newSubset2=[InfectionInd(1:end) Systolic_End(2:end)];
for i=1:size(newSubset1,1)
    S3(i) = abs(trapz(newSubset1(i,:),PPG(newSubset1(i,:))));
    S4(i) = abs(trapz(newSubset2(i,:),PPG(newSubset2(i,:))));
end
S3=median(S3);
S4=median(S4);
%% Whole Based
PredefinePAT=160;
Patp_w=0;
k=0;
while Patp_w<=PredefinePAT
    k=k+1;
Patp_w=abs(DiastolicInd(k:k+1)-Systolic(k+1:k+2));
Patd_w=abs(DiastolicInd(k:k+1)-Mean_F(k+1:k+2));
Patf_w=abs(DiastolicInd(k:k+1)-Systolic_End(k+1:k+2));
Patp_w=median(Patp_w);
Patd_w=median(Patd_w);
Patf_w=median(Patf_w);
end
PPG=(PPG-(min(PPG)))/(max(PPG)-min(PPG));
PPG(1:Systolic(k))=0;
PPG(Systolic(k+1):end)=0;
PPG(DiastolicInd(k):PredefinePAT+DiastolicInd(k))=PPG(Systolic(k+1):PredefinePAT+Systolic(k+1));
PPG_WholeFeature = resample(PPG,1,8);

end