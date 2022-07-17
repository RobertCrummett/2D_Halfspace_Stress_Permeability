%% Function Trial File
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
% Introducing Lithostatic Stress

%% User Inputs
clear; clf; close all;

% Plot Feild and Phi
feild2Plot = "XX"; % inputs: "XX","XZ","ZZ","Normal","Shear"
phi = 60; %degree from horizontal to evaluate normal/shear stress on
grdRho = 2.3; % g cm^-3, density of the ground

% Line-Load "Glacier"
initialHeight = 1000; % m
finalHeight = 700; % m
initialHalfWidth = 2000; % m
finalHalfWidth = 2000; % m

% Video File
vfileName = "TestFile";
vfileFrameRate = 10;

% Display
iter = 100; % iterations, increase for higher resolution in video file

%% Input Calculations
rho = 917; %density of ice, kg m^-3
g = 9.77; %grav acceleration (Elev. 14170 ft, Lat. -22 deg) m s^-2
phi = phi*pi/180;

% array inputs
h = linspace(initialHeight,finalHeight,iter); %glacier height, meters
a = linspace(initialHalfWidth,finalHalfWidth,iter); %glacier half-width, m
No = rho*g*h.*a; %N m^-1, the line load
A = No./(2*pi*a); % N m^-2

%% Stress Feild Calculation
step = 25; % m
x = 0:step:5000; % m
z = 0:step:3000; % m

tic
[sigma_xx, sigma_xz, sigma_zz] = XZ_Stress(A, x, z, a);
sigma_normal = Normal_Stress(sigma_xx, sigma_xz, sigma_zz, phi);
sigma_shear = Shear_Stress(sigma_xx, sigma_xz, sigma_zz, phi);
sigma_lith = Lithostatic_Stress(2.2, x, z, h, g);
fail_potential = Failure_Potential(sigma_shear, sigma_normal, sigma_lith);
toc

display_str = [0.7, 0, 0];
F = Plot_Failure_Potential(x, z, h, a, phi, fail_potential, display_str);