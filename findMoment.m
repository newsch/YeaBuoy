function Moment = findMoment(COM,COB,BuoyForce)
    r = COB - COM; % Compute the distance of the moment arm
    Moment = cross(r,BuoyForce); % compute the bouyant torque
end