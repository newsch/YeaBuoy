function force = computeBuoyForce(theta,mass)
    force = [-(10 * mass * abs(sind(theta))),10 * mass * cosd(theta),0];
end