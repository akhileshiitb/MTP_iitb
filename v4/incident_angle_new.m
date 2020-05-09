% function to find angle between two lines 
% x y z m  are previous position of photon
% z_rx is z coordinate of receiver apex of solid angle 

function [angle_of_incidence] = incident_angle(x_int,y_int,z_int,x,y,z)

    %project photon
    v1 = [x y z] ;  % previous position of photon 
    v2 = [x_int y_int z_int] ; % point of impact 
    v3 = [x_int y_int 0] ; %with z = 0 plane intersection 
    
    v1 = v1 - v2 ; 
    v3 = v3 - v2 ; % shifting origin 
    
    
    %find angle between v1 and v2 
    angle_of_incidence = (acosd(dot(v1,v3) / (norm(v1) * norm(v3)))) ; 
    %disp(angle_of_incidence); 
end
