function force = computeBuoyForce(theta,displaced_mass)
    f_bmag = 9.8*displaced_mass;
    force = [0, -sind(theta)*f_bmag, cosd(theta)*f_bmag];
end