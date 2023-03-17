%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concurrent learning disturbance observer for networked epidemic model
% Authors: Zengjie Zhang and Fangzhou Liu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

global h;                       % Discrete sampling time
global Psi;                     % We use Psi to represent exp(h*Lambda)
global kappa;                   % Observer parameter kappa
global s_lower;                 % Lower bound of S
global s_upper;                 % Upper bound of S



load("param.mat", "x0", "W", "Lambda", "delta_bar");        
                    % Load parameters
                    % x_0: initial condition of the system 
                    % W: adjacency matrix of the network
                    % Lambda: coefficient of disturbance model 
                    % delta_bar: constant curing rate 

load("exp_0_data.mat", "time", "d");
                    % Load data
                    % time: timing sequences
                    % d: ground truth disturbance

h = 0.0001;                     % Discrete sampling time
T = max(size(time));
N = min(size(W));                % Extract the number of nodes
Psi = expm(h*Lambda);            % We use Psi to represent exp(h*Lambda)

kappa = 100;
omega = 5;
o2 = -(0.5 + sqrt(0.25-h*omega))*eye(N);
o3 = (-0.5 + sqrt(0.25-h*omega))*eye(N);
s_lower = (Psi + o2)/(h*kappa);      
s_upper = (Psi + o3)/(h*kappa);

x = [x0, zeros(N,T-1)]; 

ff_gain = 1;

hat_beta = zeros(N,T);          % Estimated disturbance: proposed method

L = zeros(N, N, T);
zeta = zeros(N,T);

S = zeros(N);                   % History stacks: proposed method
X = zeros(N,1);

x_stk =[];
Concost = zeros(N,1);

for k=1:T-1

    if mod(k,0.01/h)==0 
        fprintf('Feedforward control in progress: %12f%%\n', k/(T-1)*100);
    end

    L(:, :, k) = (eye(N)-diag(x(:,k)))*W*diag(x(:,k));
    ff_term = ff_gain*L(:, :, k)*hat_beta(:,k);                          % Calculate the feedforward term

    x(:,k+1) = x(:,k) + h*(L(:, :, k)*d(:,k) - diag(x(:,k))*delta_bar - (norm(x(:,k), inf) > 0.2)*ff_term);   %- ff_term

    if k > 1
        % Stacking of the proposed observer
        zeta(:, k-1) = x(:,k) + h*diag(x(:,k-1))*delta_bar -x(:,k-1);
        x_stk = [x_stk, k-1];
        [x_stk, S, X] = history_sample_selection(k, zeta(:, x_stk), L(:, :, x_stk), x_stk, S, X);      
    end

    hat_beta(:,k+1) = Psi*hat_beta(:,k) - h*kappa*S*hat_beta(:,k) + kappa*X;
    
    % Calculate the control cost
    Concost = Concost + (delta_bar + ff_term./x(:,k)).^2;
end

save("exp_2_data.mat", "x", "time");