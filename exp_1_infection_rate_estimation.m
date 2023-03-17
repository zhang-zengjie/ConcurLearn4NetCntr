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

load("param.mat", "x0", "W", "Lambda", "beta_bar", "beta_bar_prime", "delta_bar");               
                    % Load parameters
                    % x_0: initial condition of the system 
                    % W: adjacency matrix of the network
                    % Lambda: coefficient of disturbance model 
                    % beta_bar: parameter of the infection rate model
                    % beta_bar_prime: parameter of the infection rate model
                    % delta_bar: constant curing rate 
load("exp_0_data.mat", "time", "beta");
                    % Load data
                    % time: timing sequences
                    % beta: ground truth disturbance

h = 0.0001;                     % Discrete sampling time
T = max(size(time));

N = min(size(W));                % Extract the number of nodes
Psi = expm(h*Lambda);            % We use Psi to represent exp(h*Lambda)

kappa = 100;                    % Observer parameter kappa
omega = 5;                      % Observer parameter omega
o2 = -(0.5 + sqrt(0.25-h*omega))*eye(N);
o3 = (-0.5 + sqrt(0.25-h*omega))*eye(N);
s_lower = (Psi + o2)/(h*kappa);      
s_upper = (Psi + o3)/(h*kappa);   

x = [x0, zeros(N,T-1)];                 % Initialize system state

lng_stk = zeros(1,T);           % The length of the history stacks

hat_beta = zeros(N,T);          % Estimated disturbance: proposed method
hat_beta_conv = zeros(N,T);     % Estimated disturbance: conventional method 

L = zeros(N, N, T);
zeta = zeros(N,T);

S = zeros(N);                   % History stacks: proposed method
X = zeros(N,1);
S_conv = zeros(N);              % History stacks: conventional method
X_conv = zeros(N,1);

x_stk = [];                     % Index of the stacks


% Simulation loop
for k= 1:T-1
    
    if mod(k,1/h/100)==0 
        fprintf('Disturbance estimation in progress: %3.1f%%\n', k/(T-1)*100);
    end

    L(:, :, k) = (eye(N)-diag(x(:,k)))*W*diag(x(:,k));
    x(:,k+1) = x(:,k) + h*(L(:, :, k)*beta(:,k) - diag(x(:,k))*delta_bar);
    
    if k > 1
        % Stacking of the proposed observer
        zeta(:, k-1) = x(:,k) + h*diag(x(:,k-1))*delta_bar-x(:,k-1);
        x_stk = [x_stk, k-1];
        [x_stk, S, X] = history_sample_selection(k, zeta(:, x_stk), L(:, :, x_stk), x_stk, S, X);

        % Stacking of the conventional observer
        x_stk_conv = k-1;
        X_conv = (Psi')\L(:, :, k-1)'*zeta(:, k-1);
        S_conv = (Psi')\L(:, :, k-1)'*L(:, :, k-1)/Psi;
      
    end
    % Record the length of stacks
    lng_stk(k) = numel(x_stk);

    % Estimate disturbance using the proposed observer
    hat_beta(:,k+1) = Psi*hat_beta(:,k) - h*kappa*S*hat_beta(:,k) + kappa*X;

    % Estimate disturbance using the conventional observer
    hat_beta_conv(:,k+1) = Psi*hat_beta_conv(:,k) - h*kappa*S_conv*hat_beta_conv(:,k) + kappa*X_conv;
end

save("exp_1_data.mat", "hat_beta_conv", "hat_beta", "lng_stk");
