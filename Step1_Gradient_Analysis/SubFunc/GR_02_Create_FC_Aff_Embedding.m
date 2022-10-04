function GR_02_Create_FC_Aff_Embedding(path, outPath, templatePath, ...
    subListPath, ROINumber, path_wb_command, ncomponents, pathCortical, pathROI)
% Create FC matrix, aff Matrix, & do the diffusion map embedding

Templatefile = ciftiopen(templatePath, path_wb_command);
template = Templatefile.cdata;

fileID = fopen(subListPath);
sbj = textscan(fileID,'%s'); sbj = sbj{1};
fclose(fileID);

load([path filesep '/Gradients/outmat/discard.mat']);

discard(59413:end) = 1;

bins = zeros(size(template));
for j = 1:length(ROINumber)
    bins = bins | (template == ROINumber(j));
end

% make the folder structure
if (~exist([outPath,filesep,'FCMat'],'dir'))
    mkdir([outPath,filesep,'FCMat']);
end

if (~exist([outPath,filesep,'Embedding_Result'],'dir'))
    mkdir([outPath,filesep,'Embedding_Result']);
end

all_emb = cell(length(sbj),1);
all_res = cell(length(sbj),1);

bar = waitbar(0,'Calculating�?..');

for i = 1:length(sbj)
    str=['Calculating�?..',num2str(100*i / (length(sbj) + 1)),'%'];
    waitbar(i / (length(sbj) + 1),bar,str);
    new_path_1 = fullfile(pathCortical, sbj{i});
    cii = ciftiopen([new_path_1, ...
        '/ses-01_task-rest_run-01_Atlas_s0.dtseries.nii'], path_wb_command);
    ROIcortical = cii.cdata;
    
    % get the ROI timecourses
    % the vertex-vertex FC correlation matrix
    new_path_2 = fullfile(pathROI, sbj{i});
    fileName = [new_path_2 filesep 'ROI.mat'];
    load(fileName);
    ROIcortical(discard == 1,:) = [];
    Connec_ROI = corr(ROI',ROIcortical');
    
    % save the FC matrix
    if (~exist([outPath, filesep, 'FCMat', filesep, sbj{i}], 'dir'))
        mkdir([outPath, filesep, 'FCMat', filesep, sbj{i}]);
    end
    save([outPath, filesep, 'FCMat', filesep, sbj{i}, filesep,'Connec_ROI.mat'], 'Connec_ROI');
    % transform the correlation to cosine distiance affinity matrix
    aff = connectivity2affinity(Connec_ROI');
    save([outPath, filesep, 'FCMat', filesep, sbj{i}, filesep,'ROI_aff.mat'], 'aff');
    % The diffusion map embedding
    [embedding, result] = mica_diffusionEmbedding(aff, 'nComponents', ncomponents);
    % save the result and embedding sub-wise
    save([outPath, filesep, 'FCMat', filesep, sbj{i}, filesep, 'emb.mat'], 'embedding');
    save([outPath, filesep, 'FCMat', filesep, sbj{i}, filesep, 'res.mat'], 'result');
    all_emb{i} = embedding;
    all_res{i} = result;
end

% save the embeddings af all sub in one single .mat
if (~exist([outPath, filesep, 'Group'], 'dir'))
    mkdir([outPath, filesep, 'Group']);
end
save([outPath, filesep, 'Group', filesep,'embedding_all.mat'], 'all_emb');
save([outPath, filesep, 'Group', filesep,'results_all.mat'], 'all_res');
save([outPath, filesep, 'Group', filesep,'bins.mat'], 'bins')
str=['Calculating�?..',num2str(100),'%'];
waitbar(i/length(sbj),bar,str);
close(bar);

end

