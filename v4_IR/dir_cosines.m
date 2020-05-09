

function [u_x_new, u_y_new,u_z_new] = dir_cosines(u_x, u_y, u_z,g)
    
phi_dist = makedist('uniform',0,2*pi); 
zeta_dist = makedist('uniform',0,1); 

theta = acos( (1/(2*g)) * (1 + (g^2) - (( (1 - (g^2))/( 1 - g + 2*g*random(zeta_dist)))^2) )); 
phi = random(phi_dist); 

if (u_z == 1)
    u_x_new = sin(theta)*cos(phi); 
    u_y_new = sin(theta)*sin(phi); 
    u_z_new = cos(theta); 
    
elseif (u_z == -1)
        u_x_new = sin(theta)*cos(phi); 
        u_y_new = -sin(theta)*sin(phi); 
        u_z_new = -cos(theta); 
    else
u_x_new = ((sin(theta)*(u_x*u_z*cos(phi) - u_y*sin(phi)))/sqrt(1 - (u_z^2))) + (u_x*cos(theta)) ;   
u_y_new = ((sin(theta)*(u_y*u_z*cos(phi) + u_x*sin(phi)))/sqrt(1 - (u_z^2))) + (u_y*cos(theta)) ; 
u_z_new = - (sqrt(1 - (u_z^2)) * sin(theta) * cos(phi)) + (u_z*cos(theta)) ; 
    
end
end