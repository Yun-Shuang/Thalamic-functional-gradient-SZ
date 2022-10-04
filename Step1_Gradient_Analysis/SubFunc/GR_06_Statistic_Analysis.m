function P = GR_06_Statistic_Analysis(path, embeddingPath1, ...
    embeddingPath2, templatePath, path_wb_command, ncomponents)

Templatefile = ciftiopen(templatePath, path_wb_command);
template = Templatefile.cdata;

realigned1raw = load([embeddingPath1, filesep, 'Group', filesep,'embedding_all_realigned_smooth.mat']);
realigned1raw = realigned1raw.realigned_smooth;
realigned2raw = load([embeddingPath2, filesep, 'Group', filesep,'embedding_all_realigned_smooth.mat']);
realigned2raw = realigned2raw.realigned_smooth;
% sex age meanFD
regressors = load([path,'/Gradients/outmat/Regressors177_3.mat']);

for i = 1:size(realigned1raw,2)
realigned(:,:,i) = regress_cov([reshape(realigned1raw(:,i,:),size(realigned1raw,1),size(realigned1raw,3)),reshape(realigned2raw(:,i,:),size(realigned2raw,1),size(realigned2raw,3))]',regressors.Regressors);
end

if (~exist([path filesep 'Gradients/Statistic'], 'dir'))
    mkdir([path filesep 'Gradients/Statistic']);
end

for comp = 1:ncomponents
%     if comp < 10
%         if (~exist([path,'/Gradients/Statistic/comp0', num2str(comp)], 'dir'))
%             mkdir([path,'/Gradients/Statistic/comp0', num2str(comp)])
%         end
%     else
%         if (~exist([path,'/Gradients/Statistic/comp', num2str(comp)], 'dir'))
%             mkdir([path,'/Gradients/Statistic/comp', num2str(comp)])
%         end
%     end
end

load([path filesep 'Gradients/outmat/bins.mat']);
template = zeros(size(template));
P = zeros(sum(bins), ncomponents);
for comp = 1:ncomponents
    x = realigned(1:size(realigned1raw,3),:,comp);
    y = realigned(size(realigned1raw,3)+1:end,:,comp);
    [h,p,ci,stats] = ttest2(x, y);
    P(:, comp) = p;
    newcii = Templatefile;
    template(bins) = stats.tstat;
    newcii.cdata = template;
%     if comp < 10
%         ciftisavereset(newcii, [path,'/Gradients/Statistic/comp0',...
%             num2str(comp),'/Gradient_Comp0',num2str(comp),...
%             '.T_test.dscalar.nii'], path_wb_command);
%     else
%         ciftisavereset(newcii, [path,'/Gradients/Statistic/comp',...
%             num2str(comp),'/Gradient_Comp',num2str(comp),...
%             '.T_test.dscalar.nii'], path_wb_command);
%     end
    fprintf('成分 %d, p值小于0.05个数 %d\n', comp, sum(h));
end


end

