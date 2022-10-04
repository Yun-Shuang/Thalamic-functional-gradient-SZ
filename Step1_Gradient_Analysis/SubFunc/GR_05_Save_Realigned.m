function GR_05_Save_Realigned(path, embeddingPath, templatePath, subListPath, ...
    path_wb_command, ncomponents)
% Save the Final Realigned Result

Templatefile = ciftiopen(templatePath, path_wb_command);
template = Templatefile.cdata;

fileID = fopen(subListPath);
sbj = textscan(fileID,'%s'); sbj = sbj{1};
fclose(fileID);

% Create the gradient component result folders
for comp = 1:ncomponents
    if comp < 10
        if (~exist([embeddingPath,'/Embedding_Result/Comp0',num2str(comp)], 'dir'))
            mkdir([embeddingPath,'/Embedding_Result/Comp0',num2str(comp)])
        end
    else
        if (~exist([embeddingPath,'/Embedding_Result/Comp',num2str(comp)], 'dir'))
            mkdir([embeddingPath,'/Embedding_Result/Comp',num2str(comp)])
        end
    end
end

% save the gradient component specific & subject specific to '.dscalar.nii' cifti file

gradientMesh = zeros(length(template),ncomponents);
load([embeddingPath, filesep, 'Group', filesep,'embedding_all_realigned.mat']);
load([path filesep 'Gradients/outmat/bins.mat']);
for i = 1 : length(sbj)
    gradientMesh(bins,:) = realigned(:,:,i); %#ok
    for comp = 1 : ncomponents
        newcii = Templatefile;
        newcii.cdata = gradientMesh(:,comp);
        if comp < 10
            ciftisavereset(newcii, [embeddingPath,'/Embedding_Result/Comp0',...
                num2str(comp),'/',sbj{i},'_Gradient_Comp0',num2str(comp),...
                '.dscalar.nii'], path_wb_command);
        else
            ciftisavereset(newcii, [embeddingPath,'/Embedding_Result/Comp',...
                num2str(comp),'/',sbj{i},'_Gradient_Comp',num2str(comp),...
                '.dscalar.nii'], path_wb_command);
        end
    end
end

end

