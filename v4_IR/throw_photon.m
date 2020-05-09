%throw_photon scrip new 
clear ; 
clc ; 
rx_radius = 0.5 ; % in meters i.e 50cm radius 
FOV = 90 ; % field of view in degrees 
%coefficients 
% pure sea : clear ocean : costal : Harbor 
c_vect = [0.056 0.15 0.305 2.17 0.017] ; 
a_vect = [0.053 0.069 0.088 0.295 0.015] ; 

c = c_vect(2); % for clear sea 
a = a_vect(2); 
g = 0.924 ; 
samples = 1000000 ; % number of photons per transmitsion impulse 
alpha = 10 ; % rouletting parameter 
refractive_index = 1.45 ; % refractive index of water 

rx_position = 5 ; 

catch_count = 1 ; 
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
 
while(1)
    % random r value generate 
    r = (-log(random(r_dist)))/ c ;   % random r generation 
    dist_total = dist_total + r ;
    %new weight 
    w = w*(1 - (a/c)) ; 
    if(w < (10^-4))
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
    
    %if photon reached to rx plane stop 
    if (z >= rx_position)
    % check successfull reception of photon 
[x_inter y_inter z_inter status_code] = point_of_intersect(FOV,rx_radius,rx_position,x_old,y_old,z_old,x,y,z) ;

if(status_code == 0)
    %photon lost and terminate 
    break ; 
elseif(status_code == 1)
    %photon received succesfully 
    w_acc = w_acc + w ; 
    IR_data(catch_count,1) = w ; %weight 
    IR_data(catch_count,2) = (dist_total*refractive_index) / (3*(10^8)) ; %time
    catch_count = catch_count + 1 ; 
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
 
%data processing 
%IR_data vector col 1 : weight of each photon 
% IR_data vector col 2 : time of reception at rx 

t_max = max(IR_data(:,2)); 
t_min = min(IR_data(:,2)); 

%slot time axis in n number of points 
time_slots = 10 ; % number of time slots for histogram
%iterate for time_slot times for points on histogram 
time_step = (t_max - t_min)/time_slots ; 
k = 1 ; 
for t = linspace(t_min,t_max,time_slots)
    lower_limit = t ; 
    upper_limit = t + time_step ; 
    w_t = 0 ; 
    %iterate over IR_data matrix dataset 
    for j  = 1:size(IR_data(:,2))
        if(IR_data(j,2) > lower_limit && IR_data(j,2) < upper_limit)
            %belong to this slot 
            w_t = w_t + IR_data(j,1); % collect weight of it 
        end
            
    end
    impulse_response(k) = w_t ; 
    k = k + 1 ; 
    
end
time_x = linspace(t_min,t_max,time_slots) ; 
plot(linspace(t_min,t_max,time_slots)/(10^-9),impulse_response,'-o') ; 

%save time_x and impulse_response vectors of this workspace 

