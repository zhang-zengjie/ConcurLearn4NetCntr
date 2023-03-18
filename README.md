# A Persistent-Excitation-Free Method for System Disturbance Estimation Using Concurrent Learning

**Author:** Zengjie Zhang, Fangzhou Liu

We extract the largest strongly connected subgraph containing $67$-nodes from the high school network [1] which depicts friendships between boys in a small high school in Illinois. We adjusted the adjacency matrix of the network such that it is less ill than the original version.

[1] Bonacich, Phillip, and Philip Lu. Introduction to mathematical sociology. Princeton University Press, 2012.

### The experiment parameters

Load the `param.mat` file to pull the parameters

- $\bar{d}$, `d_bar`: the parameter used to generate the sinusoidal infection rates
- $\bar{\delta}$, `delta_bar`: the baseline curing rates
- $W$, `W`: the adjacency matrix of the network
- $\Lambda$, `Lambda`: the parameter of the disturbance model
- $x(0)$, `x0`: the initial condition of the system

### Run experiment 0

Basic epidemic model controled by baseline curing rates $\bar{\delta}$

- Run the script `exp_0_generate_data.m` to generate `exp_0_data.mat`
- Then, run the script `exp_0_draw_disturbance.m` to plot the disturbance
- Then, run the script `exp_0_draw_states.m` to plot the states

### Run experiment 1

Disturbace observation using CL-based and the conventional observers

- Run the script `exp_1_infection_rate_estimation.m` to generate data `exp_1_data.mat`
- Then, run the script `exp_1_draw_disturbance_error.m` to plot the estimation errors

### Run experiment 2

Disturbance compensation control

- Run the script `exp_2_compensation_control.m` to generate data `exp_2_data.mat`
- Then, run the script `exp_2_draw_controller.m` to plot the result
