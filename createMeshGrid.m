function mesh = createMeshGrid(dy,dz,boat)
    mesh.ys = -boat.HB:dy:boat.HB;        % meters
    mesh.zs = 0:dz:boat.D;                % meters
    [mesh.ygrid,mesh.zgrid] = meshgrid(mesh.ys,mesh.zs); %create an xy meshgrid
    total_area = boat.W * boat.D;       % find the area of the subsection
    mesh.dA = total_area / numel(mesh.ygrid); % find the meshes
end