function Frames = Plot_Failure_Potential(x, z, h, a, phi, Coulomb_failure_potential,...
    display, contour_number, color_map)
% Plots the Coulomb Failure Potential In Elastic Half-Space
% Sources:
% Amos et al., (2014)
% https://www.nature.com/articles/nature13275#Sec6
%
% Inputs:
% x - Horizontal range of stress calculation. [m]
% z - Vertical range of stress calculation. [m]
% h - Vertical change of glacier height. [m]
% a - Horizontal change of glacier half-width. [m]
% phi - Angle from horizontal to project stress onto. [radians]
% Coulomb_failure_potential - Output of the Failure_Potential()
%                                                       function. [unitless]
%
% Optional Inputs:
% display - Must be a length three vector with inputs from Failure_Potential():
%           display(1) = coefficient_of_friction [unitless]
%           display(2) = pore_pressure [Pa]
%           display(3) = cohesion [Pa]
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

if exist("display","var")
    if length(display) ~= 3
        error("The optional input display must be a vector of length = three " + ...
            "with inputs = (coefficient_of_friction,pore_pressure,cohesion)")
    end
    coefficient_of_friction = display(1);
    pore_pressure = display(2);
    cohesion = display(3);
    title_string = "Coefficient of Friction = " + string(coefficient_of_friction) +...
        ", Pore Pressure = " + string(pore_pressure/(10^6)) + " MPa, Cohesion = " +...
        string(cohesion/(10^6)) + " MPa";
else
    title_string = '';
end

% Preallocating structure for speed
iterations = length(h);
Frames = struct('cdata', cell(1, iterations), 'colormap', cell(1,iterations));

% Scaling Contours
displayCon = linspace(min(Coulomb_failure_potential(:)), max(Coulomb_failure_potential(:)), contour_number);
caxCon = [min(Coulomb_failure_potential(:)), max(Coulomb_failure_potential(:))];

warning('off')
for i = 1:iterations
    
    % contour plot
    contour(x/1000,z/1000,transpose(Coulomb_failure_potential(:,:,i)),'fill','on',...
        'linestyle','none','LevelList',displayCon);
    set(gca,'YDir','reverse')
    set(gca,'XDir','reverse')
    set(gca,'TitleFontSizeMultiplier',1.2)
    ylabel('Depth (km)','Interpreter','latex')
    xlabel('Distance (km)','Interpreter','latex')
    title(strcat("Coulomb Failure Potential, ${\phi} = ",...
       string(phi*180/pi),"^{\circ}$"), title_string, 'Interpreter', 'latex')
     axis equal

    % colorbar
    colormap(color_map)
    cb = colorbar();
    caxis(caxCon)
    title(cb,'${\tau}_{xz}/{\sigma}_{Eff}$','Interpreter','latex','FontSize',12.5)

    % "glacier" animation
    ylim([(-max(h/1000) - 1/2), max(z/1000)])
    xpos = [a(i)/1000, a(i)/1000, 0, 0]';
    ypos = [0, -h(i)/1000, -h(i)/1000, 0]';
    patch(xpos, ypos, 'c')

    % frames for videofile
    Frames(i) = getframe(gcf);
end
warning('on')

end