function permeability_ratio = Permeability_Ratio_Calculator(sigma_feild, alpha, Rb)
% Calculates Relative Changes in Permeability in Elastic Half Space
% Sources:
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
% Rinaldi et al 2014
% https://link.springer.com/article/10.1007/s11242-014-0296-5
%
% Inputs:
% sigma_feild - Normal stress feild to solve for permeability. With Rinaldi's relation. 
%                           Should include additional lithostatic stress if desired. [N m^-2]
% alpha - Fudge factor in permeability ratio calculation. See Rinaldi et al
%          (2014) for details. [Pa^-1]
%          Default value is 0.13*10^(-6)
% Rb - Fudge factor in permeability ratio calculation. See Rinaldi et al
%          (2014) for details.  [unitless]
%           Default value is 0.2
% 
% Outputs:
% permeability_ratio - The change in permeability relative to the initial
%                                       condition.  [unitless]

if ~exist("alpha","var")
    alpha = 0.13*10^(-6);
end

if ~exist("Rb","var")
    Rb = 0.2;
end

permeability_ratio = ((exp(alpha*sigma_feild) + Rb)./(exp(alpha*sigma_feild(:,:,1)) + Rb)).^3; 

end
