%% boat, water, mesh init
boatSpec.L = 0.30;         % length in meters
boatSpec.W = 0.20;         % width in meters
boatSpec.HB = boatSpec.W / 2;  % half breadth in meters
boatSpec.D = 0.10;         % depth in meters

boatSpec.density = 500;    % kg / m^3
boatSpec.n = 2;            % shape parameter (dimensionless)


waterSpec.density = 1000;  % kg / m^3
waterSpec.eq = @waterRep;
waterSpec.logeq = @waterLogRep;
theta = 15;
d = 2;
%waterSpec.eq = @(y) waterRep(y, theta, d);


mesh.dx = 0.01;     % meters
dy = mesh.dx;  % meters
dz = mesh.dx;  % meters
equationBoat = @(y) (boatYZ(boatSpec,y));
boatSpec.hull = HullGenerator(mesh,equationBoat);
[masses,boatSpec] = computeMasses(mesh,boatSpec);
boatSpec.COM = centerOfMass(masses,mesh);
thetaVals = [0:20:160];
torques = zeros(1, length(thetaVals));
for j = 1:length(thetaVals)
    theta = thetaVals(j);
    fun = @(waterline) (MassDifference(waterline,boatSpec,theta,mesh,waterSpec));
    waterline = fzero(fun,0.05);
%     equationWater = @(y) waterRep(y, theta, d);
%     water = HullGenerator(mesh,equationWater);
    water = waterSpec.logeq(mesh, theta, waterline);
    displaced = boatSpec.hull & water;
    COB = centerOfMass(displaced,mesh);
    % TODO: calculate actual displaced water mass
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


% mesh = createMeshGrid(dy,dz,boatSpec);

% mesh.xs = 0:1:1;
mesh.ys = -boatSpec.HB:dy:boatSpec.HB;        % meters
mesh.zs = 0:dz:boatSpec.D;                % meters
[mesh.ygrid,mesh.zgrid] = meshgrid(mesh.ys,mesh.zs); %create an yz meshgrid
total_area = boatSpec.W * boatSpec.D;     % find the area of the subsection
mesh.dA = total_area / numel(mesh.ygrid); % find the meshes

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

function water = waterLogRep(mesh, theta, d)
    y = waterRep(mesh.ygrid, theta, d);
    if tand(theta) < 0
        water = mesh.zgrid > y;
    else
        water = mesh.zgrid < y;
    end
end