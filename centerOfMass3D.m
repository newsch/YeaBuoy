function COM = centerOfMass3D(masses, mesh)
    M = matrixSum(masses);
%     xcom = matrixSum(masses .* mesh.xgrid) / M;
    xcom = matrixSum(masses .* mesh.xgrid) / M;
    ycom = matrixSum(masses .* mesh.ygrid) / M;
    zcom = matrixSum(masses .* mesh.zgrid) / M;
    COM = [xcom, ycom,zcom];
end