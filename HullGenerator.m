function hull = HullGenerator(mesh,equation)
    y = mesh.ygrid;
    z = equation(y);
    hull = mesh.zgrid > z;
end