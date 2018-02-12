%% boat, water, mesh init
boatSpec.L = 0.30;         % length in meters
boatSpec.W = 0.20;         % width in meters
boatSpec.HB = boatSpec.W / 2;  % half breadth in meters
boatSpec.D = 0.10;         % depth in meters

boatSpec.density = 500;    % kg / m^3
boatSpec.n = 2;            % shape parameter (dimensionless)


waterSpec.density = 1000;  % kg / m^3
theta = 15;
d = 2;
%waterSpec.eq = @(y) waterRep(y, theta, d);


mesh.dx = 0.01;     % meters
dy = mesh.dx;  % meters
dz = mesh.dx;  % meters
mesh = createMeshGrid(dy,dz,boatSpec);
equationBoat = @(y) (boatYZ(boatSpec,y));
boatSpec.hull = HullGenerator(mesh,equationBoat);
[masses,boatSpec] = computeMasses(mesh,boatSpec);
boatSpec.COM = centerOfMass(masses,mesh);
thetaVals = [0:20:160];
torques = zeros([length(thetaVals)]);
 for j = 1:length(thetaVals)
    theta = thetaVals(j);
    theta
    fun = @(waterline) (MassDifference(waterline,boatSpec,theta,mesh,waterSpec.density));
    waterline = fzero(fun,0.05);
    equationWater = @(y) waterRep(y, theta, d);
    water = HullGenerator(mesh,equationWater);
    displaced = boatSpec.hull & water;
    COB = centerOfMass(displaced,mesh);
    BuoyForce = computeBuoyForce(theta,boatSpec.mass);
    torque = findMoment(boatSpec.COM,COB,BuoyForce);
    torques(j) = torque(1);
 end
 plot(thetaVals,torques);
%mesh.xs = -boatSpec.L/2:mesh.dx:boatSpec.L/2;
%mesh.ys = -boatSpec.W/2:mesh.dx:boatSpec.W/2;
%mesh.zs = 0:mesh.dx:boatSpec.D;

%[mesh.ygrid, mesh.zgrid] = meshgrid(mesh.ys, mesh.zs);
% [mesh.xgrid, mesh.ygrid, mesh.zgrid] = meshgrid(mesh.xs, mesh.ys, mesh.zs);

%% calculations
% figure; hold on
% thetaVals = [0:20:160];
% nVals = [1, 2, 10];
% torques = zeros([length(thetaVals), length(nVals)]);
% for i = 1:length(nVals)
%     n = nVals(i);
%     for j = 1:length(thetaVals)
%         theta = thetaVals(j);
%         torque =  rightingMoment(theta, n);
%         torques(j,i) = torque(1);
%     end
%     plot(thetaVals, torques(:,i))
% end
% hold off
% torques

%% functions
function z = boatYZ(boatSpec, y)
    z = boatSpec.D*abs(y/boatSpec.HB).^boatSpec.n;
end

function hull = boatLogYZ(mesh, y)
    y = boatYZ(y);
    hull = mesh.zgrid > y;
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