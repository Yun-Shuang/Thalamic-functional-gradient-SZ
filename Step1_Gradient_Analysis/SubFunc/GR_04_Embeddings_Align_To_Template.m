function GR_04_Embeddings_Align_To_Template(path, embeddingPath, ncomponents)
% Embeddings Align to a Template

% load the realign template file 
load([path, filesep , 'Gradients/AllEmbedding' filesep, 'Group', filesep, 'rp_Templ_emb.dscalar.mat']);
emb_tmpl = embedding(:,1:ncomponents); %#ok

load([embeddingPath, filesep, 'Group', filesep, 'embedding_all.mat']);
load([embeddingPath, filesep, 'Group', filesep, 'results_all.mat']);

% iteration realigned to the realign template
realigned = mica_iterativeAlignment(all_emb, 1000, emb_tmpl); %#ok
save([embeddingPath, filesep, 'Group', filesep,'embedding_all_realigned.mat'], 'realigned');

end

