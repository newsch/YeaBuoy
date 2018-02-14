%% boat, water, mesh init
boatSpec.L = 0.30;         % length in meters
boatSpec.W = 0.2;         % width in meters
boatSpec.HB = boatSpec.W / 2;  % half breadth in meters
boatSpec.D = 0.10;         % depth in meters

boatSpec.density = 500;    % kg / m^3
boatSpec.xn = 4;            % shape parameter (dimensionless)
boatSpec.yn = 3;

waterSpec.density = 1000;  % kg / m^3
waterSpec.eq = @waterRep;
waterSpec.logeq = @waterLogRep;
theta = 15;
d = 2;
%waterSpec.eq = @(y) waterRep(y, theta, d);
mast.mass = 0.096;
mast.COM = [0,0,0.3];
ballast.mass = 0.7;
ballast.COM = [0,0,0.05];


mesh.dx = 0.01;     % meters
dy = mesh.dx;  % meters
dz = mesh.dx;  % meters
%mesh.xs = -boatSpec.L/2:mesh.dx:boatSpec.L/2;
%mesh.ys = -boatSpec.W/2:mesh.dx:boatSpec.W/2;
%mesh.zs = 0:mesh.dx:boatSpec.D;

%[mesh.ygrid, mesh.zgrid] = meshgrid(mesh.ys, mesh.zs);
% [mesh.xgrid, mesh.ygrid, mesh.zgrid] = meshgrid(mesh.xs, mesh.ys, mesh.zs);

% mesh = createMeshGrid(dy,dz,boatSpec);

% mesh.xs = 0:1:1;
%mesh.ys = -boatSpec.HB:dy:boatSpec.HB;        % meters
%mesh.zs = 0:dz:boatSpec.D;                % meters
%[mesh.ygrid,mesh.zgrid] = meshgrid(mesh.ys,mesh.zs); %create an yz meshgrid
%total_area = boatSpec.W * boatSpec.D;     % find the area of the subsection
%mesh.dA = total_area / numel(mesh.ygrid); % find the meshes
mesh = createMeshGrid3D(mesh.dx,dy,dz,boatSpec);
%% calculations
equationBoat = @(x,y) (boatXYZ(boatSpec,x,y));
boatSpec.hull = HullGenerator3D(mesh,equationBoat);
[masses,boatSpec] = computeMasses3D(mesh,boatSpec);
boatSpec.COM = centerOfMass3D(masses,mesh);
boatSpec = combineCenterMass(boatSpec,mast.mass,mast.COM);
boatSpec = combineCenterMass(boatSpec,ballast.mass,ballast.COM);
thetaVals = [0:4:160];
torques = zeros(1, length(thetaVals));
for j = 1:length(thetaVals)
    theta = thetaVals(j);
    fun = @(waterline) (MassDifference3D(waterline,boatSpec,theta,mesh,waterSpec));
    waterline = fzero(fun,0.05);
%     equationWater = @(y) waterRep(y, theta, d);
%     water = HullGenerator(mesh,equationWater);
    water = waterSpec.logeq(mesh, theta, waterline);
    displaced = boatSpec.hull & water;
    COB = centerOfMass3D(displaced,mesh);
    % TODO: calculate actual displaced water mass
    BuoyForce = computeBuoyForce(theta,boatSpec.mass);
    torque = findMoment(boatSpec.COM,COB,BuoyForce);
    torques(j) = torque(1);
end
figure;
plot(thetaVals,torques);
hold on
% AVS zone
plot([120, 120], [-0.3, 0.5], '--')
plot([140, 140], [-0.3, 0.5], '--')
% plot hull w/ COM
figure;
isosurface(mesh.xgrid, mesh.ygrid, mesh.zgrid, boatSpec.hull, 0)
axis('equal')
hold on
plot3(boatSpec.COM(1), boatSpec.COM(2), boatSpec.COM(3), 'r*')

%% functions
function z = boatXYZ(boatSpec,x, y)
    z = boatSpec.D*abs(y/boatSpec.HB).^boatSpec.yn + boatSpec.D * abs(x / (boatSpec.L / 2)) .^ boatSpec.xn;
end

function hull = boatLogYZ(mesh, y)
    y = boatYZ(y);
    hull = mesh.zgrid > y;
end

function y = waterRep(x, theta, d)
    y = tand(theta).*x + d;
end

function water = waterLogRep(mesh, theta, d)
    y = waterRep(mesh.ygrid, theta, d);
    if tand(theta) < 0
        water = mesh.zgrid > y;
    else
        water = mesh.zgrid < y;
    end
end