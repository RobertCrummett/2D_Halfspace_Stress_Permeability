function [Frame] = PlotPermeability(sigma_xx, sigma_xz, sigma_zz, phi, alp, Rb, h, a, x, z, addLith, con)
% Plotting Relative Permeability Changes due to Line Load
% Sources:
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
% Rinaldi et al 2014
% https://link.springer.com/article/10.1007/s11242-014-0296-5
%
% Variables:
% sigma_xx - Stress feild in xx direction. Output from Sigmas().
% sigma_xz - Stress feild in xz direction. Output from Sigmas().
% sigma_zz - Stress feild in zz direction. Output from Sigmas().
% phi - Angle from horizontal to project stresses onto. (radians)
% alp - Fudge factor in permeability ratio calculation. See Rinaldi et al
%               (2014) for details. They used 0.13*10^(-6) Pa^-1
% Rb - Fudge factor in permeability ratio calculation. See Rinaldi et al
%               (2014) for details. They used 0.2 (unitless)
% h - Vertical change of glacier height. (m)
%       Same as in Sigmas().
% a - Horizontal change of glacier half-width. (m)
%       Same as in Sigmas().
% x - Horizontal range of stress calculation. (m)
%       Same as in Sigmas().
% z - Vertical range of stress calculation. (m)
%       Same as in Sigmas().
% addLith - True means add lithostatic stress. False means do not add.
%                   Default is 0. 
% con - Number of contours to plot. Must be positive scalar. Default is 15.

if ~exist("addLith","var")
    addLith = 0;
end

if ~exist("con", "var")
    con = 15;
end

% Calculate Normal Stress
sigma_n = sigma_zz*cos(phi)^2 - 2*sigma_xz*sin(phi)*cos(phi) + sigma_xx*sin(phi)^2;

% Lithostatic Stress
if addLith
    % Ground Density is 2.3 g cm^-3
    grdRho = 2.3*(100^3)/1000*ones([length(x) length(z) length(h)]);
    zmat = repmat(z, [length(x) 1 length(h)]);
    g = 9.8;
    sigma_lith = grdRho.*g.*zmat;
    % Add Feilds
    sigma_n = sigma_n - sigma_lith; % consistent signs
end

% Permeability Ratio
k_ratio = ((exp(alp*sigma_n) + Rb)./(exp(alp*sigma_n(:,:,1)) + Rb)).^3; 

% Preallocating structure for speed
iter = length(h);
Frame = struct('cdata', cell(1, iter), 'colormap', cell(1,iter));

% Scaling Contours
displayCon = linspace(min(k_ratio(:)), max(k_ratio(:)), con);
caxCon = [min(k_ratio(:)), max(k_ratio(:))];

warning('off')
for i = 1:iter
    
    % contour plot
    contour(x/1000,z/1000,transpose(k_ratio(:,:,i)),'fill','on','linestyle','none','LevelList',...
        displayCon);
    set(gca,'YDir','reverse')
    set(gca,'XDir','reverse')
    set(gca,'TitleFontSizeMultiplier',1.4)
    ylabel('Depth (km)','Interpreter','latex')
    xlabel('Distance (km)','Interpreter','latex')
    title(strcat("Permeability Ratio, ${\phi} = ",string(phi*180/pi),"^{\circ}$"),...
       strcat(strcat("Height = ",string(round(h(i),0,"decimals"))," m"),", ",...
       strcat("Half-Width = ",string(round(a(i),0,"decimals"))," m")),'Interpreter','latex')
     axis equal

    % colorbar
    colormap("jet")
    cb = colorbar;
    caxis(caxCon)
    title(cb,'${\kappa}/{\kappa}_{i}$','Interpreter','latex','FontSize',12.5)
    
    % "glacier" animation
    ylim([(-max(h/1000) - 1/2), max(z/1000)])
    xpos = [a(i)/1000, a(i)/1000, 0, 0]';
    ypos = [0, -h(i)/1000, -h(i)/1000, 0]';
    patch(xpos, ypos, 'c')

    % frames for videofile
    Frame(i) = getframe(gcf);
end
warning('on')


end