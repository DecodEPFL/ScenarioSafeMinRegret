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
violations_dr = zeros(size(dataset));
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
        % Solution without restricting the number of optimization variables
        qf_cost_reg = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg); dataset{j}.Phi_u_reg]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg); dataset{j}.Phi_u_reg];
        qf_reg_reg = qf_cost_reg - qf_cost_psi;
        if norm(qf_reg_reg, 2) > dataset{j}.obj_reg
            violations(j) = violations(j) + 1;
        end
        % Solution with diagonally-restricted closed-loop map 
        qf_cost_reg_dr = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg_dr); dataset{j}.Phi_u_reg_dr]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*dataset{j}.Phi_u_reg_dr); dataset{j}.Phi_u_reg_dr];
        qf_reg_reg_dr = qf_cost_reg_dr - qf_cost_psi;
        if norm(qf_reg_reg_dr, 2) > dataset{j}.obj_reg_dr
            violations_dr(j) = violations_dr(j) + 1;
        end
    end
end

opt.beta = 0.1;
opt.delta = 1 + sys.n*sys.m*opt.T*(opt.T-1)/2;
opt.delta_dr = 1 + sys.n*sys.m*(opt.T-1);

epsilons = [];
epsilons_dr = [];

for j = 15:size(dataset, 2)
    epsilons(j - 14) = 2/dataset{j}.opt.N*(opt.delta + log10(1/opt.beta));
end
for j = 6:size(dataset, 2)
    epsilons_dr(j - 5) = 2/dataset{j}.opt.N*(opt.delta_dr + log10(1/opt.beta));
end


N = [];
R = []; R_dr = [];
H = []; H_dr = [];
solver_time = [];
solver_time_dr = [];
for j = 1:size(dataset, 2)
    N = [N, dataset{j}.opt.N];
    R = [R, dataset{j}.obj_reg];
    H = [H, dataset{j}.obj_inf];
    solver_time = [solver_time, dataset{j}.sol_reg.solvertime];
    R_dr = [R_dr, dataset{j}.obj_reg_dr];
    H_dr = [H_dr, dataset{j}.obj_inf_dr];
    solver_time_dr = [solver_time_dr, dataset{j}.sol_reg_dr.solvertime]; 
end