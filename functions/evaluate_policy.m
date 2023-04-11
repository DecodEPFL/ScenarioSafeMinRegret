function [cum_cost] = evaluate_policy(sls, opt, Phi, Ai, Bi, w)
%EVALUATE_POLICY computes the cumulative cost incurred applying the policy 
%corresponding to the closed-loop responses in Phi in response to 
%the disturbance realization w
    
    % Compute the input-state trajectory associated with the disturbance w 
    x = (sls.I - sls.Z*Ai)\(sls.I + sls.Z*Bi*Phi) * w; 
    u = Phi * w; 
    
    % Compute the incurred cumulative cost
    cum_cost = [x; u]'*opt.C*[x; u];
    
end