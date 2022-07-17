function Coulomb_failure_potential = Failure_Potential(sigma_shear, sigma_normal, ...
    sigma_lithostatic, pore_pressure, coefficent_of_friction, cohesion)
% Calculates the Coulomb failure potential along a fault.
% Source:
% Amos et al., (2014)
% https://www.nature.com/articles/nature13275#Sec6
%
% Inputs:
% sigma_shear - Output from Shear_Stress() function. [N m^-2]
% sigma_normal - Output from Normal_Stress() function. [N m^-2]
% sigma_lithostatic - Output from Lithostatic_Stress() function. [N m^-2]
% pore_pressure - Fluid pore pressure. Reduces the effective normal stress.
%                               Should be a positive number. [N m^-2]
%                               Default value is 0
% coefficent_of_friction - The coefficent of friction along the fault.
%                                             [unitless]
%                                             Default value is 0.7
% cohesion - The cohesion of the fault. [N m^-2]
%                     Default value is 0
%
% Outputs:
% Coulomb_failure_potential - The failure potential for a fault. [unitless]
%                                                       Values greater than one indicate a potential to failure.

if ~exist("pore_pressure","var")
    pore_pressure = 0;
end

if ~exist("coefficent_of_friction","var")
    coefficent_of_friction = 0.7;
end

if ~exist("cohesion","var")
    cohesion = 0;
end

effective_normal_stress = - sigma_normal + sigma_lithostatic;

Coulomb_failure_potential = abs(sigma_shear)./(coefficent_of_friction*...
    (effective_normal_stress - pore_pressure) + cohesion);

end