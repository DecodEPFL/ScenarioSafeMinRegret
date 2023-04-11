initialize_control_problem;
% Load the data
dataset{1} = load('data_T20_N10_kc_0p8_1p2_double_integrator.mat'); 
dataset{2} = load('data_T20_N20_kc_0p8_1p2_double_integrator.mat'); 
dataset{3} = load('data_T20_N30_kc_0p8_1p2_double_integrator.mat'); 
dataset{4} = load('data_T20_N50_kc_0p8_1p2_double_integrator.mat'); 
dataset{5} = load('data_T20_N70_kc_0p8_1p2_double_integrator.mat'); 
dataset{6} = load('data_T20_N100_kc_0p8_1p2_double_integrator.mat'); 
dataset{7} = load('data_T20_N150_kc_0p8_1p2_double_integrator.mat'); 
dataset{8} = load('data_T20_N200_kc_0p8_1p2_double_integrator.mat'); 
dataset{9} = load('data_T20_N250_kc_0p8_1p2_double_integrator.mat'); 
dataset{10} = load('data_T20_N300_kc_0p8_1p2_double_integrator.mat'); 
dataset{11} = load('data_T20_N400_kc_0p8_1p2_double_integrator.mat'); 
dataset{12} = load('data_T20_N500_kc_0p8_1p2_double_integrator.mat'); 
dataset{13} = load('data_T20_N600_kc_0p8_1p2_double_integrator.mat'); 
dataset{14} = load('data_T20_N700_kc_0p8_1p2_double_integrator.mat'); 
dataset{15} = load('data_T20_N800_kc_0p8_1p2_double_integrator.mat'); 
dataset{16} = load('data_T20_N1000_kc_0p8_1p2_double_integrator.mat'); 
dataset{17} = load('data_T20_N1500_kc_0p8_1p2_double_integrator.mat'); 
dataset{18} = load('data_T20_N2000_kc_0p8_1p2_double_integrator.mat'); 

validation_samples = 10000;
violations = zeros(size(dataset));
for i = 1:validation_samples
    % Sample a new uncertainty realization
    theta = [0.2; 0.2].*(2*rand() - 1);
    % Evaluate the corresponding system dynamics over the entire horizon
    [Ai, Bi] = evaluate_sampled_scenario(sys, sls, theta);
    
    % Compute the corresponding clairvoyant control policy
    psi = scenario_clairvoyant_unconstrained(sys, sls, opt, theta);
    qf_cost_psi = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*psi); psi]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*psi); psi];
    % For each robust control policy...
    for j = 1:size(dataset, 2)
        qf_cost_reg = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg_robust); dataset{j}.Phi_u_reg_robust]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg_robust); dataset{j}.Phi_u_reg_robust];
        qf_reg_reg = qf_cost_reg - qf_cost_psi;
        
        if norm(qf_reg_reg, 2) > dataset{j}.objective_reg_robust
            violations(j) = violations(j) + 1;
        end
    end
end

opt.beta = 0.1;
opt.delta = 1 +(sys.m*(opt.T-1)*(2*sys.n + sys.n*(opt.T-2)))/2;

epsilons = [];
for j = 15:size(dataset, 2)
    epsilons(j - 14) = 2/dataset{j}.opt.N*(opt.delta + log10(1/opt.beta));
end

N = [];
R = [];
H = [];
for j = 1:size(dataset, 2)
    N = [N, dataset{j}.opt.N];
    R = [R, dataset{j}.objective_reg_robust];
    H = [H, dataset{j}.objective_inf_robust];
end