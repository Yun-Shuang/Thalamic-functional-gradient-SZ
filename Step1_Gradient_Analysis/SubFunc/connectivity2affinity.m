function affinityMatrix = connectivity2affinity(connectivityMatrix, sparsity)
% Calculate the 'affinity angle' matrix from the connectivity matrix. 
% from Reinder, slightly adapted by B2 
% ---- 
if nargin == 1
    sparsity = 90;  % Margulies-sparsity  
end

cutoffValues        = prctile(connectivityMatrix, sparsity);
thresholdMatrix     = bsxfun(@gt, connectivityMatrix, cutoffValues) .* connectivityMatrix;
affinityMatrix      = 1-squareform(pdist(thresholdMatrix.','cosine'));
