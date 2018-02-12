function matrixSum(A)
    % matrixSum: returns total of all elements in the matrix
    % A: matrix
    % returns: scalar
    
    % normally sum(m) computes the sums of the columns
    % selecting m(:) flattens the matrix and computes the sum of all elements
    % see https://stackoverflow.com/questions/1721987/what-are-the-ways-to-sum-matrix-elements-in-matlab
    M = sum(A(:));
end