%function to find point of intersect of line with xy plane 
% z_rx is receiver circle plane to solve equation  rx_position 
% r is radius of receiver 
% FOV is field of view of receiver 
% status_code = 0 : photon lost terminate 
% status_code = 1 : Photon received 
% status_code = 2 : FOV failed, give another chance 
% x1,y1,z1 is previous position of photon 
% x2 y2 z2 is current position of photon 
function [x,y,z,status_code] = point_of_intersect(FOV,r,z_rx,x1,y1,z1,x2,y2,z2)

    delta = (z_rx - z2)/ (z2 - z1) ; 
    z = z_rx ; 
    x = delta*(x2-x1) + x2 ; 
    y = delta*(y2-y1) + y2 ; 
    
    %check if x y point lies inside circle 
    
    if (((x^2) + (y^2) - (r^2)  ) < 0)
        %point lies inside the circle 
        %check for angle of incidence and FOV condition 
        % find apex of solid angle of FOC using rx as sphere as assumption
       % rx_apex = z_rx + (r / sind(FOV/2)) ; % get rx_apex 
        angle_of_incidence = incident_angle_new(x,y,z,x1,y1,z1); 
        if(angle_of_incidence <= (FOV/2))
            status_code = 1 ; 
        else
            status_code = 2 ; %return photon to previous position and continue
        end
    else
        status_code = 0 ; 
        %break the photon 
    end
    
end