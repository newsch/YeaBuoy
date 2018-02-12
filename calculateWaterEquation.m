function waterEq = calculateWaterEquation(y,theta,waterline)
    waterEq = tand(theta) .* y + waterline;
end