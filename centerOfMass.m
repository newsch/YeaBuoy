function COM = centerOfMass(masses, mesh)
    M = matrixSum(masses);
%     xcom = matrixSum(masses .* mesh.xgrid) / M;
    xcom = 0;
    ycom = matrixSum(masses .* mesh.ygrid) / M;
    zcom = matrixSum(masses .* mesh.zgrid) / M;
    COM = [xcom, ycom,zcom];
end