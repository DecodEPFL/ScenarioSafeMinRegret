function [Phi_u, objective, sol] = dr_robust_regret_unconstrained(sys, sls, opt, theta)

    % Define the decision variables of the optimization problem
    %Phi_u = sdpvar(sys.m*opt.T, sys.n*opt.T, 'full');
    
    % Define the diagonally-restricted closed-loop map Phi_u 
    vector_Phi_u = sdpvar(sys.m*opt.T, sys.n, 'full');
    temp = eye(opt.T);
    Phi_u = kron(temp, vector_Phi_u(1:sys.m, :));
    for i = 1:(opt.T - 1)
        temp = diag(ones(opt.T - i, 1), -i);
        Phi_u = Phi_u + kron(temp, vector_Phi_u((i*sys.m + 1):((i + 1)*sys.m), :));
    end

    gamma = sdpvar(1, 1, 'full'); % Upper bound
    
    % Define the objective function
    objective = gamma;
   
    constraints = [];
    % Impose the causal sparsities on the closed loop responses
%     for i = 0:opt.T-2
%         for j = i+1:opt.T-1 % Set j from i+2 for non-strictly causal controller (first element in w is x0)
%             constraints = [constraints, Phi_u((1+i*sys.m):((i+1)*sys.m), (1+j*sys.n):((j+1)*sys.n)) == zeros(sys.m, sys.n)];
%         end
%     end
%     constraints = [constraints, Phi_u((1 + sys.m*(opt.T - 1)):sys.m*opt.T, :) == zeros(sys.m, sys.n*opt.T)];
    
    for i = 1:size(theta, 2)
        theta_i = theta(:, i);
        
        [Ai, Bi] = evaluate_sampled_scenario(sys, sls, theta_i);
        
        Psi_u_i = scenario_clairvoyant_unconstrained(sys, sls, opt, theta_i); % Compute the corresponding clairvoyant benchmark
        % Compute the matrix that defines the quadratic form measuring the cost incurred by the benchmark controller
        J_psi_i = [(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Psi_u_i); Psi_u_i]'*opt.C*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Psi_u_i); Psi_u_i];
        
        % Impose the constraints deriving from the Schur complement
        P_i = [eye((sys.n+sys.m)*opt.T) sqrtm(opt.C)*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u); Phi_u]; (sqrtm(opt.C)*[(sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi_u); Phi_u])' gamma*eye(sys.n*opt.T) + J_psi_i];
        
        constraints = [constraints, P_i >= 0];
        constraints = [constraints, gamma >= 0];
        
    end
    
    % Solve the optimization problem
    options = sdpsettings('verbose', 0, 'solver', 'mosek');
    sol = optimize(constraints, objective, options);
    if ~(sol.problem == 0)
        error('Something went wrong...');
    end

    Phi_u = value(Phi_u);
    objective = value(objective);
    
end