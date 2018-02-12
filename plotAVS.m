function plotAVS(boat,water,dy,dz)
    mesh = creatMeshGrid(dy,dz,boat);
    equationBoat = boatLogYZ();
    boat.hull = HullGenerator(mesh,equationBoat);
    masses = computeMasses(mesh,boat);
    boat.COM = centerOfMass(masses,mesh);
    fun = @(waterline) (MassDifference(waterline,boat,theta,mesh));
    waterline = fzero(fun,0.05);
    equationWater = @(y) waterRep(y, theta, d);
    
    