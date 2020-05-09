%throw_photon scrip new 
clear ; 
clc ; 
rx_radius = 0.5 ; % in meters i.e 50cm radius 
FOV = 180 ; % field of view in degrees 
%coefficients 
% pure sea : clear ocean : costal : Harbor 
c_vect = [0.056 0.15 0.305 2.17 0.017] ; 
a_vect = [0.053 0.069 0.088 0.295 0.015] ; 

c = c_vect(4); % for clear sea 
a = a_vect(4); 
g = 0.924 ; 
samples = 10 ; % number of photons per transmitsion impulse 
alpha = 10 ; % rouletting parameter 
refractive_index = 1 ; % refractive index of water 
q1 = 1 ; 
for rx_position = linspace(0.1,10,20)
catch_count = 0 ; 
w_acc = 0 ;


for i=1:samples 
    
x = 0 ; 
y = 0 ; 
z = 0 ; % initial position of photon 

x_old = 0 ; 
y_old = 0 ; 
z_old = 0 ; 
 
dir_cosine = [0;0;1] ; % initial direction cosines 

% finding new direction cosine and moving photon 

w = 1 ; % initial weight 
r_dist = makedist('uniform',0,1) ; 
roulette_dist = makedist('uniform',0,1); 
dist_total = 0 ; 
position(1,1) = 0 ; 
position(1,2) = 0 ; 
position(1,3) = 0 ; 
k = 2 ;  
while(1)
    % random r value generate 
    r = (-log(random(r_dist)))/ c ;   % random r generation 
    
    dist_total = dist_total + r ; 
    %new weight 
    w = w*(1 - (a/c)) ; 
    if(w < (10^-6))
        % routlet process for photon 
        % Accounts for conservation of energy 
        X = random(roulette_dist); 
        if(X > (1/alpha))
            break; 
        elseif(X <= (1/alpha))
            w = alpha*w ; 
        end
    end 
    %calculate new direction cosines 
   [dir_cosine(1) dir_cosine(2) dir_cosine(3)] = dir_cosines(dir_cosine(1), dir_cosine(2), dir_cosine(3),g) ; 
    %move photon to new position 
    x = x + r*dir_cosine(1) ; 
    y = y + r*dir_cosine(2) ; 
    z = z + r*dir_cosine(3) ; 
    
    %store new postions 
    %position(k,1) = x ; 
    %position(k,2) = y ; 
    %position(k,3) = z ; 
    k = k + 1 ; 
    
    %if photon reached to rx plane stop 
    if (z >= rx_position)
    % check successfull reception of photon 
[x_inter y_inter z_inter status_code] = point_of_intersect(FOV,rx_radius,rx_position,x_old,y_old,z_old,x,y,z) ;

if(status_code == 0)
    %photon lost and terminate 
    break ; 
elseif(status_code == 1)
    %photon received succesfully 
    catch_count = catch_count + 1 ; 
    w_acc = w_acc + w ; 
    break ; 
elseif(status_code == 2)
    break ; 
end

    end
    
    x_old = x ; 
    y_old = y ; 
    z_old = z ; 
    
end   % end of one photon 


end %end of samples num of photons 


    intensity(q1) = w_acc ; 
    q1 = q1 + 1 ; 
end

intensity = intensity/intensity(1) ; %normalized power 
plot(linspace(0.1,10,20),intensity,'-o'); 
grid on ; 
grid minor ; 
title('Power attenuation','FontSize',16); 
xlabel('Receiver distance [m]','FontSize',16); 
ylabel('Normalized Received Power','FontSize',16); 
%legend({'c = 0.056 : Pure sea','c = 0.15 : Clear ocean ','c = 0.305 : Costal water'},'FontSize',16);

hold on ; 

%beer lanberts law plot for normalized power 
%beer = exp(-c*linspace(0,4,10)); 
%plot(linspace(0,4,10),beer,'-d'); 

