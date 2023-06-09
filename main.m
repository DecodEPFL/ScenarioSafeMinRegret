%% Martin et al. - "Regret Optimal Control for Uncertain Stochastic Systems"
clc; close all; clear;
addpath('./functions') % Add path to the folder with auxiliary functions
addpath('./data')      % Add path to the folder with stored data
rng(1234);             % Set random seed for reproducibility
%% Definition of the underlying uncertain stochastic discrete-time system and of the optimal control problem
initialize_control_problem;
%% Robust control design using random sampling of the uncertain parameters
opt.N = 10; % Number of sampled scenarios
theta = [0.2; 0.2].*(2*rand(2, opt.N) - 1); % Obtain instances of the uncertain parameters
tic
[Phi_u_reg, obj_reg] = robust_regret_unconstrained(sys, sls, opt, theta); % Objective is the worst-case regret
[Phi_u_inf, obj_inf] = robust_hinf_unconstrained  (sys, sls, opt, theta); % Objective is the square root of the worst-case cost
toc
%% Experiment 1: empirical validation of probabilistic regret guarantee
clc; close all; clear;
addpath('./functions') % Add path to the folder with auxiliary functions
addpath('./data')      % Add path to the folder with stored data
rng(5678);             % Set random seed for reproducibility
source_file = './data/experiment1.mat';
if isfile(source_file)
    load(source_file);
    plot_empirical_violation_probability;
    plot_worst_case_regret_guarantee;
else
    generate_data_experiment1;
    save experiment1
end 
%% Experiment 2: closed-loop performance comparison
clc; close all; clear;
addpath('./functions') % Add path to the folder with auxiliary functions
addpath('./data')      % Add path to the folder with stored data
rng(1910);             % Set random seed for reproducibility
source_file = './data/experiment2.mat';
if isfile(source_file)
    load(source_file);
    compare_cost_upper_bound;
    compare_closed_loop_cost;
else
    generate_data_experiment2;
    save experiment2
end 