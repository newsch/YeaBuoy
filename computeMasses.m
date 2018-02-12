function [masses,boat] = computeMasses(mesh,boat)
    boat.num_cells = matrixSum(boat.hull);         % computes # of cells in the boat
    boat.area = boat.num_cells * mesh.dA;          % computes area of boat
    boat.volume = boat.area * boat.L;              % computes the volume of the boat
    boat.mass = boat.volume * boat.density;
    boat.mass_per_cell = boat.mass / boat.num_cells;  % mass per cell
    masses = boat.hull * boat.mass_per_cell;  % flip the boat
end