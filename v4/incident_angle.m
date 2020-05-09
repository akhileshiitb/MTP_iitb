% function to find angle between two lines 
% x y z m  are previous position of photon
% z_rx is z coordinate of receiver apex of solid angle 

function [angle_of_incidence] = incident_angle(z_rx,x,y,z)

    %project photon
    v1 = [x y z] ; 
    v2 = [0 0 0] ; 
    % shift the rx_plane 
    v1(3) = v1(3) - z_rx ; 
    v2(3) = v2(3) - z_rx ; 
    
    %find angle between v1 and v2 
    angle_of_incidence = (acosd(dot(v1,v2) / (norm(v1) * norm(v2)))) ; 
    disp(angle_of_incidence); 
end
