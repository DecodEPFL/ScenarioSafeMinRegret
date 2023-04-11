%% Definition of the underlying uncertain stochastic discrete-time system
% Definition of universal constants
sys.Ts = 1; % Sampling time
sys.k = 1;  % Spring constant
sys.c = 1;  % Damping constant
sys.m = 1;  % Mass
% State-space equations of mass-spring-damper system
sys.theta = sym('theta', [2 1]);
sys.A = [1 sys.Ts; -(sys.k + sys.theta(1))*sys.Ts/sys.m 1 - (sys.c + sys.theta(2))*sys.Ts/sys.m];
sys.B = [0; sys.Ts/sys.m];

sys.n = size(sys.A, 1);   % Order of the system
sys.m = size(sys.B, 2);   % Number of input channels
%% Definition of the control horizon and the weighting matrices
opt.T = 20;

opt.Qt = eye(sys.n); % Stage cost: state weight matrix
opt.Rt = eye(sys.m); % Stage cost: input weight matrix

opt.Q = kron(eye(opt.T), opt.Qt); % State cost matrix
opt.R = kron(eye(opt.T), opt.Rt); % Input cost matrix
opt.C = blkdiag(opt.Q, opt.R); % Cost matrix
%% Definition of the stacked system dynamics over the control horizon
sls.A = kron(eye(opt.T), sys.A);
sls.B = kron(eye(opt.T), sys.B);
% Identity matrix and block-downshift operator
sls.I = eye(sys.n*opt.T); 
sls.Z = [zeros(sys.n, sys.n*(opt.T-1)) zeros(sys.n, sys.n); eye(sys.n*(opt.T-1)) zeros(sys.n*(opt.T-1), sys.n)];