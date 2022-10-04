function [ datat ] = regress_cov( data,regressors )
%REGRESS_COV Summary of this function goes here
%   Detailed explanation goes here
if ~isempty(regressors)
    disp('removing regressors from data...');
    datat = zeros(size(data));
    for cont = 1:size(data,2)
       sig = data(:,cont);
       if ~all(isnan(sig))
          B = glmfit(regressors,sig,'normal');
          datat(:,cont) = sig - regressors * B(2:end);
       else
           datat(:,cont) = sig;
       end
    end
else
    datat = data;
end

end

