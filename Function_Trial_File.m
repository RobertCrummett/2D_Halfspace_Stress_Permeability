%% Function Trial File
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
% Introducing Lithostatic Stress

%% User Inputs
clear; clf; close all;

% Video File
vfileNamePerm = "H1300A16000_retreat_perm";
vfileNameLith = "H1300A16000_retreat_lith";
vfileNamePermLith = "H1300A16000_retreat_permlith";

vfileFrameRate = 15;

% Plot Feild and Phi
phi = 60; %degree from horizontal to evaluate normal/shear stress on
grdRho = 2.3; % g cm^-3, density of the ground

% Line-Load "Glacier"
initialHeight = 1300; % m
finalHeight = 1300; % m
initialHalfWidth = 16000; % m
finalHalfWidth = 1000; % m

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
step = 100; % m
x = 0:step:17000; % m
step = 25;
z = 0:step:3500; % m

tic
[sigma_xx, sigma_xz, sigma_zz] = XZ_Stress(A, x, z, a);
sigma_normal = Normal_Stress(sigma_xx, sigma_xz, sigma_zz, phi);
sigma_lith = Lithostatic_Stress(grdRho,x,z,h,g);
k = Permeability_Ratio_Calculator(sigma_normal);
k_2 = Permeability_Ratio_Calculator(sigma_normal - sigma_lith);
toc

display_str = [0.7, 0, 0];
G = Plot_Permeability_Ratio(x,z,h,a,phi,k);
H = Plot_Stress_Feild(x, z, h, a, phi, sigma_normal - sigma_lith,"Normal");
I = Plot_Permeability_Ratio(x,z,h,a,phi,k_2);

%% Video File
Create_Video_File(G,vfileNamePerm,vfileFrameRate)
Create_Video_File(H,vfileNameLith,vfileFrameRate)
Create_Video_File(I,vfileNamePermLith,vfileFrameRate)
