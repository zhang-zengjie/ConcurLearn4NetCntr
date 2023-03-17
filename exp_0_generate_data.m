%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concurrent learning disturbance observer for networked epidemic model
% Authors: Zengjie Zhang and Fangzhou Liu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

h = 0.0001;                     % Discrete sampling time
t_final = 5;                    % Total simulation time
time = 0:h:t_final;
T = t_final/h + 1;

load("param.mat", "x0", "W", "beta_bar", "delta_bar");                 
                    % Load parameters
                    % x0: initial condition of the system 
                    % W: adjacency matrix of the network
                    % Lambda: coefficient of disturbance model 
                    % beta_bar: parameter of the infection rate model
                    % beta_bar_prime: parameter of the infection rate model
                    % delta_bar: constant curing rate 

N = min(size(W));

x = [x0, zeros(N,T-1)];                 % Initialize system state

beta = zeros(N,T);              % Generate disturbance
for i=1:T
    beta(:,i) = beta_bar*(1+0.5*sin(2*time(i)));
end


% Simulation loop
for k= 1:T
    
    L = (eye(N)-diag(x(:,k)))*W*diag(x(:,k));
    x(:,k+1) = x(:,k) + h*(L*beta(:,k) - diag(x(:,k))*delta_bar);
    
end

save("exp_0_data.mat", "x", "time", "beta");