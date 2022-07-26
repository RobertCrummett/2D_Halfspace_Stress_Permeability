function sigma_shear = Shear_Stress(sigma_xx, sigma_xz, sigma_zz, phi)
% Normal Stress Feild from Line Load
% Source:
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
%
% Inputs:
% Outputs from the XZ_Stress() function. [N m^-2]
% phi - Angle from horizontal to project stress onto. [radians]
%
% Outputs:
% sigma_shear = Shear stress field. [N m^-2]

sigma_shear = (sigma_zz - sigma_xx)*sin(phi)*cos(phi) + sigma_xz*(cos(phi)^2 - sin(phi)^2);

end