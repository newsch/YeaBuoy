function difference = MassDifference3D(waterline,boat,theta,mesh,waterSpec)
   water = waterSpec.logeq(mesh, theta, waterline);
   sub_region = boat.hull & water;
   num_cells_water = matrixSum(sub_region);
   volume_water = num_cells_water * mesh.dV;
   mass_water = volume_water * waterSpec.density;
   difference = mass_water - boat.mass;
end