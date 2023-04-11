load('data_T20_N5000_kc_0p8_1p2_double_integrator.mat'); % Load the data

considered_dynamics = 20;
iter = 10000;
for i  = 1:considered_dynamics
    % Sample a scenario for evaluation
    theta_test = [0.2; 0.2].*(2*rand(2, 1) - 1);
    [Ai, Bi] = evaluate_sampled_scenario(sys, sls, theta_test);
    % Get the corresponding cost matrices
    cost_qf_reg = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u_reg_robust); Phi_u_reg_robust]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u_reg_robust); Phi_u_reg_robust];
    cost_qf_inf = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u_inf_robust); Phi_u_inf_robust]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u_inf_robust); Phi_u_inf_robust];
    % Get the corresponding clairvoyant optimal policy and its cost matrix
    psi = scenario_clairvoyant_unconstrained(sys, sls, opt, theta_test); 
    cost_qf_psi = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*psi); psi]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*psi); psi];
    for j = 1:6 % For each disturbance profiles
        repeat = [iter iter 1 1 1 1];
        for k = 1:repeat(j)
            if j == 1
                w = randn(sys.n*opt.T, 1); 
            elseif j == 2
                w = rand(sys.n*opt.T, 1);
            elseif j == 3
                w = ones(sys.n*opt.T, 1); w = cumsum(w); w = w/w(end);
            elseif j == 4
                w = ones(sys.n*opt.T, 1);
            elseif j == 5
                w = [-ones(sys.n*(opt.T - floor(opt.T/2)), 1); ones(sys.n*floor(opt.T/2), 1)];
            else
                [reg_evectors, reg_evalues] = eig(cost_qf_reg);
                [inf_evectors, inf_evalues] = eig(cost_qf_inf);
                [psi_evectors, psi_evalues] = eig(cost_qf_psi);
                
                reg_evalues = diag(reg_evalues);
                inf_evalues = diag(inf_evalues);
                psi_evalues = diag(psi_evalues);

                [~, reg_index] = max(reg_evalues);
                [~, inf_index] = max(inf_evalues);
                [~, psi_index] = max(psi_evalues);

                wreg = reg_evectors(:, reg_index);
                winf = inf_evectors(:, inf_index);
                wpsi = psi_evectors(:, psi_index);
            end
            if ~(j == 6)
                w = w/norm(w);
                wreg = w; winf = w; wpsi = w;
            end
            cost_reg(i, j, k) = wreg'*cost_qf_reg*wreg;
            cost_inf(i, j, k) = winf'*cost_qf_inf*winf;
            cost_psi(i, j, k) = wpsi'*cost_qf_psi*wpsi;
        end
    end
end
%%
cost_reg_gaussian = reshape((cost_reg(:, 1, :)), considered_dynamics, iter)';
cost_inf_gaussian = reshape((cost_inf(:, 1, :)), considered_dynamics, iter)';
cost_psi_gaussian = reshape((cost_psi(:, 1, :)), considered_dynamics, iter)';
avg_gap_gaussian = mean((cost_reg_gaussian - cost_inf_gaussian)./cost_reg_gaussian);

cost_reg_uniform = reshape((cost_reg(:, 2, :)), considered_dynamics, iter)';
cost_inf_uniform = reshape((cost_inf(:, 2, :)), considered_dynamics, iter)';
cost_psi_uniform = reshape((cost_psi(:, 2, :)), considered_dynamics, iter)';
avg_gap_uniform = mean((cost_reg_uniform - cost_inf_uniform)./cost_reg_uniform);

cost_reg_ramp = reshape((cost_reg(:, 3, 1)), considered_dynamics, 1)';
cost_inf_ramp = reshape((cost_inf(:, 3, 1)), considered_dynamics, 1)';
cost_psi_ramp = reshape((cost_psi(:, 3, 1)), considered_dynamics, 1)';
avg_gap_ramp = (cost_reg_ramp - cost_inf_ramp)./cost_reg_ramp;

cost_reg_constant = reshape((cost_reg(:, 4, 1)), considered_dynamics, 1)';
cost_inf_constant = reshape((cost_inf(:, 4, 1)), considered_dynamics, 1)';
cost_psi_constant = reshape((cost_psi(:, 4, 1)), considered_dynamics, 1)';
avg_gap_constant = (cost_reg_constant - cost_inf_constant)./cost_reg_constant;

cost_reg_stairs = reshape((cost_reg(:, 5, 1)), considered_dynamics, 1)';
cost_inf_stairs = reshape((cost_inf(:, 5, 1)), considered_dynamics, 1)';
cost_psi_stairs = reshape((cost_psi(:, 5, 1)), considered_dynamics, 1)';
avg_gap_stairs = (cost_reg_stairs - cost_inf_stairs)./cost_reg_stairs;

cost_reg_worst = reshape((cost_reg(:, 6, 1)), considered_dynamics, 1)';
cost_inf_worst = reshape((cost_inf(:, 6, 1)), considered_dynamics, 1)';
cost_psi_worst = reshape((cost_psi(:, 6, 1)), considered_dynamics, 1)';
avg_gap_worst = (cost_reg_worst - cost_inf_worst)./cost_reg_worst;