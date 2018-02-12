function difference = MassDifference(waterline,boat,theta,mesh,density)
   logicaleq = @(y) (calculateWaterEquation(y,waterline,theta));
   water = HullGenerator(mesh,logicaleq);
   sub_region = boat.hull & water;
   num_cells_water = matrixSum(sub_region);
   area_water = num_cells_water * mesh.dA;
   volume_water = area_water * boat.L;
   mass_water = volume_water * density;
   difference = mass_water - boat.mass;
end