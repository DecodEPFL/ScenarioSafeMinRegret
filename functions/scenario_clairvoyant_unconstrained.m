function [Phi_u] = scenario_clairvoyant_unconstrained(sys, sls, opt, theta_i)
    
    [Ai, Bi] = evaluate_sampled_scenario(sys, sls, theta_i);
    
    Fi = inv(sls.I - sls.Z*Ai)*sls.Z*Bi;
    Gi = inv(sls.I - sls.Z*Ai);
    Phi_u = -inv(opt.R + Fi'*opt.Q*Fi)*Fi'*opt.Q*Gi;
    
end