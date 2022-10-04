function GR_00_Discard_Vertex(path, inPath1, subListPath1, ...
    inPath2, subListPath2, templatePath, path_wb_command)

template = ciftiopen(templatePath, path_wb_command); 
template = template.cdata;

fileID1 = fopen(subListPath1);
sbj1 = textscan(fileID1,'%s'); sbj1 = sbj1{1};
fclose(fileID1);

fileID2 = fopen(subListPath2);
sbj2 = textscan(fileID2,'%s'); sbj2 = sbj2{1};
fclose(fileID2);

discard = zeros(size(template));

% index = zeros(size(template));
% for j = 0:47
%     index = index | (template == j);
% end

% fp1 = fopen([path filesep 'GradientCode/out/Discard_SCH.txt'], 'at');
% fp2 = fopen([path filesep 'GradientCode/out/Discard_HC.txt'], 'at');

for i = 1:length(sbj1)
    fileName = fullfile(inPath1, sbj1{i}, 'MNINonLinear',...
        'Results', 'ses-01_task-rest_run-01',...
        'ses-01_task-rest_run-01_Atlas_s0.dtseries.nii');
    cdata = ciftiopen(fileName,path_wb_command);
    cdata = cdata.cdata;
    del = ~any(cdata,2);
    discard = discard | del;
%     fprintf(fp1, '%s 删除 %d 个顶点\n', sbj1{i}, sum(del .* (~index)));
end

% fclose(fp1);

for i = 1:length(sbj2)
    fileName = fullfile(inPath2, sbj2{i}, 'MNINonLinear',...
        'Results', 'ses-01_task-rest_run-01',...
        'ses-01_task-rest_run-01_Atlas_s0.dtseries.nii');
    cdata = ciftiopen(fileName,path_wb_command);
    cdata = cdata.cdata;
    del = ~any(cdata,2);
    discard = discard | del;
%     fprintf(fp2, '%s 删除 %d 个顶点\n', sbj2{i}, sum(del(45:end)));
end

% fclose(fp2);

if (~exist([path filesep 'Gradients/outmat'], 'dir'))
    mkdir([path filesep 'Gradients/outmat']);
end
save([path filesep 'Gradients/outmat/discard.mat'], 'discard');

end

