function mesh = createMeshGrid3D(dx,dy,dz,boat)
    mesh.xs = -boat.L / 2:dx:boat.L / 2;
    mesh.ys = -boat.HB:dy:boat.HB;        % meters
    mesh.zs = 0:dz:boat.D;                % meters
    [mesh.xgrid,mesh.ygrid,mesh.zgrid] = meshgrid(mesh.xs,mesh.ys,mesh.zs); %create an xy meshgrid
    total_volume = boat.W * boat.D * boat.L;       % find the area of the subsection
    mesh.dV = total_volume / numel(mesh.ygrid); % find the meshes
end