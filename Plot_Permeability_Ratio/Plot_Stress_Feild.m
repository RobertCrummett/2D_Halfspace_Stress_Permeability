function Frames = Plot_Stress_Feild(x, z, h, a, phi, sigma_feild, feild_name, contour_number, color_map)
% Plots the XX, XZ, ZZ, Normal, or Shear Stress Feild In Elastic Half-Space
%
% Inputs:
% x - Horizontal range of stress calculation. [m]
% z - Vertical range of stress calculation. [m]
% h - Vertical change of glacier height. [m]
% a - Horizontal change of glacier half-width. [m]
% phi - Angle from horizontal to project stress onto. [radians]
% sigma_feild - Stress feild to plot. [N m^-2]
% feild_name - Indicate feild type with string:
%           "XX" - XX Stress Feild
%           "XZ" - XZ Stress Feild
%           "ZZ" - ZZ Stress Feild
%           "Normal" - Normal Stress Feild
%           "Shear" - Shear Stress Feild
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
Frames = struct('cdata',cell(1,iterations),'colormap',cell(1,iterations));

% Plot Contours
displayCon = linspace(min(sigma_feild(:)),max(sigma_feild(:)),contour_number);
caxCon = [min(sigma_feild(:)), max(sigma_feild(:))];
titleStr = strcat(feild_name, " Stress Feild, ");

warning('off')
for i = 1:iterations
    
    % Contour Plot
    contour(x/1000, z/1000, transpose(sigma_feild(:,:,i)),'fill','on','linestyle','none','LevelList',...
        displayCon);
    set(gca,'YDir','reverse')
    set(gca,'XDir','reverse')
    set(gca,'TitleFontSizeMultiplier',1.4)
    ylabel('Depth (km)','Interpreter','latex')
    xlabel('Distance (km)','Interpreter','latex')
    title([strcat(titleStr, "${\phi} = ",string(phi*180/pi),"^{\circ}$");...
       strcat(strcat("Height = ",string(round(h(i),0,"decimals"))," m"),", ",...
       strcat("Half-Width = ",string(round(a(i),0,"decimals"))," m"))],'Interpreter','latex')

    % Colorbar
    colormap(color_map)
    cb = colorbar;
    caxis(caxCon)
    title(cb,'${MPa}$','Interpreter','latex','FontSize',11)
    
    % Glacier Animation
    ylim([(-max(h/1000) - 1/2), max(z/1000)])
    xpos = [a(i)/1000, a(i)/1000, 0, 0]';
    ypos = [0, -h(i)/1000, -h(i)/1000, 0]';
    patch(xpos, ypos, 'c')

    % frames for videofile
    Frames(i) = getframe(gcf);
    axis equal
end
warning('on')
axis equal

% positive indicates compression

end