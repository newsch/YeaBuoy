boatSpec.L = 0.30;         % length in meters
boatSpec.W = 0.20;         % width in meters
boatSpec.HB = boatSpec.W / 2;  % half breadth in meters
boatSpec.D = 0.10;         % depth in meters

boatSpec.density = 500;    % kg / m^3
boatSpec.n = 2;            % shape parameter (dimensionless)


waterSpec.density = 1000;  % kg / m^3
theta = 15;
d = 2;
waterSpec.eq = @(y) waterRep(y, theta, d);


mesh.dx = 0.01;     % meters
mesh.dy = mesh.dy;  % meters
mesh.dz = mesh.dz;  % meters

mesh.xs = 


function z = boatYZ(y)
    pass;
end

function y = waterRep(x, theta, d)
    y = tand(theta).*x + d;
end

function water = waterLogRep(mesh, x, theta, d)
    y = waterRep(x, theta, d);
    if tand(theta) < 0
        water = mesh.zgrid > y;
    else
        water = mesh.zgrid < y;
    end
end