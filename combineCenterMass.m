function boat = combineCenterMass(boat,mass,COM)
    boat.COM = (boat.COM .* boat.mass + COM .* mass) ./ (boat.mass+mass);
    boat.mass = boat.mass + mass;
end