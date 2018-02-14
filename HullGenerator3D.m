function hull = HullGenerator3D(mesh,equation)
    x = mesh.xgrid;
    y = mesh.ygrid;
    z = equation(x,y);
    hull = mesh.zgrid > z;
end