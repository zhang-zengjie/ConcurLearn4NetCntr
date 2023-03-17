%% The history stack management procedure
% Author: Zengjie Zhang
% Input: k -> the current time instant
%        zeta -> the difference term for all stacked instants
%        L -> the disturbance gain for all stacked instants
%        x_stk -> the queue of sampling instants
%        S, X -> the history stacks

function [x_stk, S, X] = history_sample_selection(k, zeta, L, x_stk, S, X)

global Psi;
global s_upper;
global s_lower;

S_prime = S + L(:, :, end)'*L(:, :, end);
S = (Psi')\S_prime/Psi;
X_prime = X + L(:, :, end)'*zeta(:, end);
X = (Psi')\X_prime;

for ss = 1:max(size(x_stk))
    temp = S - (Psi')^(x_stk(ss)-k)*L(:, :, ss)'*L(:, :, ss)*(Psi)^(x_stk(ss)-k);
    if min(eig(temp - s_lower))>0 || min(eig(s_upper - temp))<0
        S = temp;
        X = X - (Psi')^(x_stk(ss)-k)*L(:, :, ss)'*zeta(:, ss);
    else
        break;
    end
end

x_stk = x_stk(ss:end);