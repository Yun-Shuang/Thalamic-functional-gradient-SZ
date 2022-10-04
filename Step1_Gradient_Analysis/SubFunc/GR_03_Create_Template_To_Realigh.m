function GR_03_Create_Template_To_Realigh(embeddingPath, embeddingPath1, embeddingPath2, ...
    subListPath1, subListPath2, ncomponents)
% Average All Sub's FC Matrix and Do Embedding to Yeild a Template to Realign

fileID1 = fopen(subListPath1);
sbj1 = textscan(fileID1,'%s'); sbj1 = sbj1{1};
fclose(fileID1);

fileID2 = fopen(subListPath2);
sbj2 = textscan(fileID2,'%s'); sbj2 = sbj2{1};
fclose(fileID2);

Grp_dconn = zeros(2536,57582);

for sub = 1 : length(sbj1)
    dconn = importdata(fullfile(embeddingPath1, 'FCMat', ...
        sbj1{sub}, 'Connec_ROI.mat'));
    if (~exist('Grp_dconn', 'var'))
        Grp_dconn = zeros(size(dconn));
    end
    Grp_dconn = Grp_dconn + dconn;
end

for sub = 1 : length(sbj2)
    dconn = importdata(fullfile(embeddingPath2, 'FCMat', ...
        sbj2{sub}, 'Connec_ROI.mat'));
    Grp_dconn = Grp_dconn + dconn;
end

% average all sub's zconn
if (~exist([embeddingPath, filesep, 'Group'], 'dir'))
    mkdir([embeddingPath, filesep, 'Group']);
end
Grp_dconn_Avg = Grp_dconn / (length(sbj1) + length(sbj2));
Grp_aff = connectivity2affinity(Grp_dconn_Avg');
save([embeddingPath, filesep, 'Group', filesep,'Grp_dconn_Avg.mat'], 'Grp_dconn_Avg')
save([embeddingPath, filesep, 'Group', filesep,'Grp_aff.mat'], 'Grp_aff')
% do embedding with the group average affinity matrix
[embedding, result] = mica_diffusionEmbedding(Grp_aff, 'nComponents', ncomponents); %#ok
% save the group template to .mat & .dscalar.nii file
save([embeddingPath, filesep, 'Group', filesep, 'Grp_Templ_emb.mat'], 'embedding')
save([embeddingPath, filesep, 'Group', filesep, 'Grp_Templ_res.mat'], 'result')
save([embeddingPath, filesep, 'Group', filesep, 'rp_Templ_emb.dscalar.mat'], 'embedding');

end

