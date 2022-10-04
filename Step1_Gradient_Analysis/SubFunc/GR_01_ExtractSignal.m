function GR_01_ExtractSignal(path, inPath, outPath, templatePath, ...
     subListPath, ROINumber, path_wb_command)

template = ciftiopen(templatePath, path_wb_command); 
template = template.cdata;

fileID = fopen(subListPath);
sbj = textscan(fileID,'%s'); sbj = sbj{1};
fclose(fileID);

outPathCortical = [outPath '/Cortical'];
outPathROI = [outPath '/ROI'];

if (~exist(outPathCortical,'dir'))
    mkdir(outPathCortical);
end

if (~exist(outPathROI,'dir'))
    mkdir(outPathROI);
end

load([path filesep 'Gradients/outmat/discard.mat']);
discard(1:59412) = 1;
bins = zeros(size(template));
for j = 1:length(ROINumber)
    bins = bins | (template == ROINumber(j));
end
bins = bins & (~discard);

save([path filesep 'Gradients/outmat/bins.mat'], 'bins');

bar = waitbar(0,'Calculating�?..');

for i = 1:length(sbj)
    str=['Calculating�?..',num2str(100*i/length(sbj)),'%'];
    waitbar(i/length(sbj),bar,str);
    fileName = fullfile(inPath, sbj{i}, 'MNINonLinear',...
        'Results', 'ses-01_task-rest_run-01',...
        'ses-01_task-rest_run-01_Atlas_s0.dtseries.nii');
    if (~exist([outPathCortical filesep sbj{i}],'dir'))
        mkdir([outPathCortical filesep sbj{i}]);
    end
    cdata = ciftiopen(fileName,path_wb_command);
    
    copyfile(fileName, [outPathCortical filesep sbj{i}]);
    
    cdata = cdata.cdata;
    ROI = cdata(bins,:); %#ok
    if (~exist([outPathROI filesep sbj{i}],'dir'))
        mkdir([outPathROI filesep sbj{i}]);
    end
    save([outPathROI filesep sbj{i} filesep 'ROI.mat'],'ROI');
    
end

close(bar);

end

