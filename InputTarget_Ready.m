function [Data_ParameterBased,Data_WholeBased,TargetDBP,TargetSBP]=InputTarget_Ready(Patd,Patf,Patp,AI,LASI,S1,S2,S3,S4,heart_rate,PPG_WholeFeature,SBP,DBP,Remove,Number_Case_Wanted)
Data_ParameterBased=[];
Data_WholeBased=[];
TargetDBP=[];
TargetSBP=[];
NCW=0;
for i=1:4
       if (NCW>Number_Case_Wanted)
              break; 
       end
   for j=1:size(SBP{i},2)
       
       NCW=NCW+1;
       if (NCW>Number_Case_Wanted)
              break; 
       end
       
       a= i==Remove(:,1);
       ShouldRemoveInd=find(Remove(a,2)==j, 1);
       if(~isempty(ShouldRemoveInd))
          continue 
       end
     try  
       Data_ParameterBased=[Data_ParameterBased; Patd{i,j},Patf{i,j},Patp{i,j},AI{i,j},LASI{i,j},S1{i,j},S2{i,j},S3{i,j},S4{i,j},heart_rate{i,j}];
       Data_WholeBased=[Data_WholeBased;PPG_WholeFeature{i,j}];

       TargetDBP=[TargetDBP;round(DBP{i}(j))];
       TargetSBP=[TargetSBP;round(SBP{i}(j))];
    catch
         if (NCW>Number_Case_Wanted)
              break; 
       end
    end

end
 
end


end