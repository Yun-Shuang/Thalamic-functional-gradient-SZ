clc;clear;


path = '/media/shuang/data';
inPath = [path '/COSshanxi/CII/EOS'];
outPath = [path '/Gradients/FunctionalData/EOS'];
templatePath = [path,...
    '/Gradients/Template/null_lL_WG33/Gordon333_FreesurferSubcortical.32k_fs_LR.dlabel.nii'];
subListPath = [path '/Gradients/Lists/final_list_EOS.txt'];
%          L   R
ROINumber = [346,347];
path_wb_command = '/home/shuang/software/workbench-linux64-v1.4.2/workbench/bin_linux64/wb_command';


%% GR_00_Discard_Vertex
inPath1 = [path '/COSshanxi/CII/EOS']; inPath2 = [path '/COSshanxi/CII/HC'];
subListPath1 = [path '/Gradients/Lists/final_list_EOS.txt'];
subListPath2 = [path '/Gradients/Lists/final_list_HC.txt'];

GR_00_Discard_Vertex(path, inPath1, subListPath1, ...
    inPath2, subListPath2, templatePath, path_wb_command);

%% GR_01_ExtractSignal

GR_01_ExtractSignal(path,inPath,outPath,templatePath,subListPath,...
    ROINumber,path_wb_command);

%% GR_02_Create_FC_Aff_Embedding
embeddingPath = [path '/Gradients/AllEmbedding/EOS'];
ncomponents = 10;
pathCortical = [outPath '/Cortical'];
pathROI = [outPath '/ROI'];

GR_02_Create_FC_Aff_Embedding(path, embeddingPath, templatePath, ...
    subListPath, ROINumber, path_wb_command, ncomponents, pathCortical, pathROI);

%% GR_03_Create_Template_To_Realigh

GR_03_Create_Template_To_Realigh([path '/AllEmbedding'], [path '/AllEmbedding/EOS'], ...
[path '/AllEmbedding/HC'], subListPath1, subListPath2, ncomponents);

%% GR_04_Embeddings_Align_To_Template

GR_04_Embeddings_Align_To_Template(path, embeddingPath, ncomponents);

%% GR_05_Save_Realigned

GR_05_Save_Realigned(path, embeddingPath, templatePath, subListPath,...
    path_wb_command, ncomponents);

%% GR_06_Statistic_Analysis
%SMOOTH should be done before this step
p = GR_06_Statistic_Analysis(path, [path '/Gradients/AllEmbedding/EOS'], ...
    [path '/Gradients/AllEmbedding/HC'], templatePath, path_wb_command, 2);
% FDR = mafdr(p(:));

