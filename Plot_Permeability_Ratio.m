function Frames = Plot_Permeability_Ratio(x, z, h, a, phi, permeability_ratio,...
    contour_number, color_map)
% Plots the Change of Permeability Ratio In Elastic Half-Space
% Sources:
% Amos et al 2014
% https://www.nature.com/articles/nature13275#Sec6
% Rinaldi et al 2014
% https://link.springer.com/article/10.1007/s11242-014-0296-5
%
% Inputs:
% x - Horizontal range of stress calculation. [m]
% z - Vertical range of stress calculation. [m]
% h - Vertical change of glacier height. [m]
% a - Horizontal change of glacier half-width. [m]
% phi - Angle from horizontal to project stress onto. [radians]
% permeability_ratio - Output of the Permeability_Ratio_Calculator()
%                                       function. [unitless]
%
% Optional Inputs:
% countour_number - The number of contours to display.
%                                       Default is 15
% color_map - The colormap to display.
%                         Default is 'jet'
% Outputs:
% Frames - The frames to make a video with.

if ~exist("contour_number","var")
    contour_number = 15;
end

if ~exist("color_map","var")
    color_map = 'jet';
end

% Preallocating structure for speed
iterations = length(h);
Frames = struct('cdata', cell(1, iterations), 'colormap', cell(1,iterations));

% Scaling Contours
displayCon = linspace(min(permeability_ratio(:)), max(permeability_ratio(:)), contour_number);
caxCon = [min(permeability_ratio(:)), max(permeability_ratio(:))];

warning('off')
for i = 1:iterations
    
    % contour plot
    contour(x/1000,z/1000,transpose(permeability_ratio(:,:,i)),'fill','on',...
        'linestyle','none','LevelList',displayCon);
    set(gca,'YDir','reverse')
    set(gca,'XDir','reverse')
    set(gca,'TitleFontSizeMultiplier',1.4)
    ylabel('Depth (km)','Interpreter','latex')
    xlabel('Distance (km)','Interpreter','latex')
    title(strcat("Permeability Ratio ${\kappa}/{\kappa}_{i}$, ${\phi} = ",...
       string(phi*180/pi),"^{\circ}$"),...
       strcat(strcat("Height = ",string(round(h(i),0,"decimals"))," m"),", ",...
       strcat("Half-Width = ",string(round(a(i),0,"decimals"))," m")),'Interpreter','latex')
     axis equal

    % colorbar
    colormap(color_map)
    cb = colorbar;
    caxis(caxCon)
    title(cb,'${\kappa}/{\kappa}_{i}$','Interpreter','latex','FontSize',12.5)
    
    % "glacier" animation
    ylim([(-max(h/1000) - 1/2), max(z/1000)])
    xpos = [a(i)/1000, a(i)/1000, 0, 0]';
    ypos = [0, -h(i)/1000, -h(i)/1000, 0]';
    patch(xpos, ypos, 'c')

    drawnow
    % frames for videofile
    Frames(i) = getframe(gcf);
end
warning('on')

end