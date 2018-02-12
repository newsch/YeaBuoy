function hull = HullGenerator(mesh,equation)
    y = mesh.y;
    z = equation(y);
    hull = mesh.zgrid > z;
end