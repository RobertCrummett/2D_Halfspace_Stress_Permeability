function sigma_normal = Normal_Stress(sigma_xx, sigma_xz, sigma_zz, phi)
% Normal Stress Feild from Line Load
% Source:
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
%
% Inputs:
% Outputs from the XZ_Stress() function
% phi - Angle from horizontal to project stress onto. [radians]
%
% Outputs:
% sigma_normal = Normal stress field.

sigma_normal = sigma_zz*cos(phi)^2 - 2*sigma_xz*sin(phi)*cos(phi) + sigma_xx*sin(phi)^2;
 
end