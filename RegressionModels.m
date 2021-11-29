function RegressionModels(Data,Target,Name)
%% Remove Nan
Indx=isnan(Target);
Data(Indx,:)=[];
Target(Indx)=[];
%% Regression linear
mdlRegLinear = fitrlinear(Data,Target,'KFold',10);
Out{1}=FindBest_CV(mdlRegLinear,Data,Target);
PlotResults(Target,Out{1} ,[Name ' Linear']);
%% Tree
tree = fitrtree(Data,Target,'CrossVal','on','KFold',10);
Out{2} =FindBest_CV(tree,Data,Target);
PlotResults(Target,Out{2} ,[Name ' Tree']);
%% SVM
svm=fitrsvm(Data,Target,'KernelFunction','rbf','CrossVal','on','KFold',10,'Solver','ISDA');
Out{3}=FindBest_CV(svm,Data,Target);
PlotResults(Target,Out{3} ,[Name ' SVM']);
%% Adaboost
RegTreeTemp = templateTree('Surrogate','On');
Adaboost=fitensemble(Data,Target,'LSBoost',400,RegTreeTemp,'CrossVal','on','KFold',10);
Out{4}=FindBest_CV(Adaboost,Data,Target);
PlotResults(Target,Out{4} ,[Name ' Adaboost']);
%% Random Forest
Forest=fitensemble(Data,Target,'LSBoost',400,'Tree','CrossVal','on','KFold',10);
Out{5}=FindBest_CV(Forest,Data,Target);
PlotResults(Target,Out{5} ,[Name ' RandomForest']);

end