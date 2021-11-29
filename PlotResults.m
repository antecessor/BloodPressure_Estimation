function PlotResults(targets,outputs,Name)

    errors=targets-outputs;
    errors(isinf(errors))=[];
    errors(isnan(errors))=[];
    outputs(isnan(outputs))=[];
    targets(isnan(targets))=[];
    RMSE=sqrt(mean(errors(:).^2));
    
    error_mean=mean(errors(:));
    error_std=std(errors(:));
    error_mae=mae(errors);
    figure
    subplot(2,2,[1 2]);
    plot(targets,'k');
    hold on;
    plot(outputs,'r');
    legend('Target','Output');
    title(Name);

    subplot(2,2,3);
    plot(errors);
    legend('Error');
    title(['RMSE = ' num2str(RMSE)]);

    subplot(2,2,4);
    histfit(errors);
    title(['Error: MAE = ' num2str(error_mae) ', std = ' num2str(error_std)]);
    pause(.001)
end