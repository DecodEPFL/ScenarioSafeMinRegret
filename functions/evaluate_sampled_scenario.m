function [Ai, Bi] = evaluate_sampled_scenario(sys, sls, theta_i)

    Ai = double(subs(sls.A, sys.theta, theta_i));
    Bi = double(subs(sls.B, sys.theta, theta_i));
    
end

