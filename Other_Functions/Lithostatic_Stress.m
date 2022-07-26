function sigma_lithostatic = Lithostatic_Stress(Density_Matrix, x, z, h, acceleration_gravity)
% Lithostatic Stress Calculator in Elastic Half Space Model
% 
% Inputs:
% Density_Matrix - Matrix of size [length(x) length(z) length(h)] with
%                                  values of density at each point.     [g cm^-3]
%                                  If scalar is provided, constant density
%                                  is assumed.      [g cm^-3]
% x - Horizontal range of stress calculation. [m]
%       Same as input into XZ_Stress() function.
% z - Vertical range of stress calculation. [m]
%       Same as input into XZ_Stress() function.
% h - Vertical change of glacier height. [m]
%
% Optional Inputs:
% acceleration_gravity - Acceleration due to gravity. Scalar quantity.  [m s^-2]
%                                          Default value is 9.8
%
% Outputs:
% sigma_lithostatic - The lithostatic stress due to the lithostatic load.
%                                     [N m^-2]

n_x = length(x);
n_z = length(z);
n_h = length(h);

if isequal(size(Density_Matrix),[1 1])
    rho = Density_Matrix*1000*ones([n_x n_z n_h]);
else
    rho = Density_Matrix;
end

if ~exist("acceleration_gravity","var")
    acceleration_gravity = 9.8;
end

z_grid = repmat(z, [n_x, 1, n_h]);

sigma_lithostatic = rho.*acceleration_gravity.*z_grid;

end