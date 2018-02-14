function [masses,boat] = computeMasses3D(mesh,boat)
    boat.num_cells = matrixSum(boat.hull);         % computes # of cells in the boat
    boat.volume = boat.num_cells * mesh.dV;          % computes area of boat
    boat.mass = boat.volume * boat.density;
    boat.mass_per_cell = boat.mass / boat.num_cells;  % mass per cell
    masses = boat.hull * boat.mass_per_cell;  % flip the boat
end