function [FinalDiastolicInd,FinalInfectionInd]=DiastolicPoint_InfectionPoint(Signal,Subset,pks_sys,Fs)
D2=diff(Signal,2);
smtlb = sgolayfilt(D2,4,71);
smtlb(1:100)=0;smtlb(end-100:end)=0;
smtlb=smtlb/max(smtlb);
[b,a] = butter(8,50/Fs/2); %% 50 Hz
smtlb=filtfilt(b,a,smtlb);
%% Diastolic
[pks_dias,locs_dias]=findpeaks(smtlb,'MinPeakHeight',0);
 Sys_Peak=pks_dias>mean(pks_sys)/2; %% delete systolic
 pks_dias(Sys_Peak)=[];
 locs_dias(Sys_Peak)=[];
newSubset=[Subset(1:end-1,1) Subset(2:end,2)];
for i=1:size(newSubset,1)
   Val=locs_dias>=newSubset(i,1)+10 & locs_dias<=newSubset(i,2)-10;
   if sum(Val)==0
       DiastolicInd(i)=0;
       continue 
   end
   Set=find(Val==1);  
   [~,ind]=max(pks_dias(Val));
    DiastolicInd(i)=Set(ind);
end
DiastolicInd(DiastolicInd==0)=[];
FinalDiastolicInd=locs_dias(DiastolicInd);
%% Infection
[pks_Inf,locs_Inf]=findpeaks(-smtlb,'MinPeakHeight',0);
 Sys_Peak=pks_Inf>mean(pks_sys)/2; %% delete systolic
 pks_Inf(Sys_Peak)=[];
 locs_Inf(Sys_Peak)=[];
for i=1:size(newSubset,1)
   Val=locs_Inf>=newSubset(i,1)+10 & locs_Inf<=newSubset(i,2)-10;
   Set=find(Val==1);  
   [~,ind]=max(pks_Inf(Val));
    InfectionInd(i)=Set(ind);
end
FinalInfectionInd=locs_Inf(InfectionInd);
end