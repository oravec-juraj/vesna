%%
yalmip('clear')
%%
% Model data
Z = 0.0127; % system gain
T = 13.0164*20; % time constant

% Continuous state-space system
Ac = [-1/T];
Bc = [Z/T];
Cc = [1];
Dc = [0];
sysC = ss(Ac, Bc, Cc, Dc);

%Discrete-time state-space system
Ts = 60; % Sampling time
sysD = c2d(sysC, Ts)
[A, B, C, D] = ssdata(sysD);

% Problem size
nx = size(A,1); % Number of states
% Problem size
nx = size(A,1); % Number of states
nu = size(B,2); % Number of inputs
ny = size(C,1); % Number of outputs

At = [A, zeros(nx); -C*Ts, eye(ny)];
Bt = [B; zeros(nu)];
St = [zeros(ny); Ts*eye(ny)];

% Initial conditinon
x0 = [ -2 ];
w0 = [ 5 ];
XI0 = [ 0 ];

% Control constraints
u_min = [ -128 ]; 
u_max = [  128 ];
x_min = [  -10 ]; 
x_max = [   10 ]; 

% MPC data
Q = eye( nx )*1000;
Qi = eye( ny )*1000;
R = eye( nu )*1.5;
N = 50; % Prediction horizon

% Decision variables
u = sdpvar(repmat(nu,1,N), repmat(1,1,N));
x = sdpvar(repmat(nx,1,N+1), repmat(1,1,N+1));
xi = sdpvar(repmat(ny,1,N+1), repmat(1,1,N+1));
w = sdpvar(repmat(ny,1,N+1), repmat(1,1,N+1));
xt = [x; xi];

% Optimization problem
constraints = [ ];
objective = 0;
for k = 1 : N
%   objective = objective + xt{k}'*Qt*xt{k} + u{k}'*R*u{k}; % Cost function
    objective = objective + x{k}'*Q*x{k} + xi{k}'*Qi*xi{k} + u{k}'*R*u{k}; % Cost function
    constraints = [ constraints,  x{ k+1 } == A*x{ k } + B*u{ k } ];
    constraints = [ constraints, xi{ k+1 } == -C*Ts*x{ k } + xi{ k }];
    constraints = [ constraints, u_min <= u{ k }<= u_max, x_min <= x{ k+1 } <= x_max];
    constraints = [ constraints, w{ k+1 } == w{ k } ];
end

sol = optimize([ constraints, x{1} == x0, w{1} == w0; xi{1} == XI0 ], objective)

parameters_in = { x{1} , w{1}, xi{1} };
solutions_out = {[u{:}], [x{:}]};

opt = sdpsettings('solver', 'gurobi');

global MPC_controller
MPC_controller = optimizer(constraints, objective,opt,parameters_in,solutions_out);

[out, flag ] = MPC_controller( x0, w0, XI0 ) % MPC controller evaluation
u_opt = out{1}(:,:) % Optimal control action
x_opt = out{2}(:,:) % Predicted states

% Initialization of the measurements for the real closed-loop control
global Ww Yy Uu XI
Ww = [];
Yy = [];
Uu = [];
XI = 0;

% Simulationof the closed-loop control
figure, hold on
for i = 1:nu
    stairs(0:N-1, u_opt(i, :), 'b')
end
hold on
plot(0:N, zeros(1, N+1), 'r--')
hold on
plot(0:N, u_min*ones(1, N+1), 'm-.')
hold on 
plot(0:N, u_max*ones(1, N+1), 'm-.')
xlabel('Predikcny horizont $N$', 'interpreter', 'latex', 'FontSize', 15)
ylabel('$u$', 'interpreter', 'latex', 'FontSize', 15)
legend('$u$', 'ziadana hodnota', 'ohranicenia','interpreter', 'latex','FontSize', 10)
f2p('u_opt')

figure, hold on
for i = 1:nx
    stairs(0:N, x_opt(i, :), 'b')
end
hold on
plot(0:N, ones(1, N+1), 'r--')
hold on
plot(0:N, x_min*ones(1, N+1), 'm-.')
hold on
plot(0:N, x_max*ones(1, N+1), 'm-.')
xlabel('Predikcny horizont $N$', 'interpreter', 'latex', 'FontSize', 15)
ylabel('$x [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
legend('$x$', 'ziadana hodnota', 'ohranicenia', 'interpreter', 'latex', 'FontSize', 10)
f2p('x_opt')


Nsim = 30; % Pocet krokov simulacie
Xdata = x0;
XIdata = XI0;
Wdata = w0;

for k = 1:Nsim
    xk = Xdata(:, k); % Simulation of meassurement
    xik = XIdata(:, k); % Simulation of meassurement
    [uk, Flag_k] = MPC_controller(xk, w0, xik); % Control law
    if (Flag_k == 0)
        Flag_info = 'Succesfully solved';
    else
        Flag_info = 'Problem detected!'; 
    end
    disp(sprintf('Step %d/%d : %s', k, Nsim, Flag_info)) % Verbose mode
    Udata(:, k) =  uk{1}(1); % Extract the first control step
    Xdata(:, k+1) = A*Xdata(:, k) + B*Udata(:, k); % Model/Plant update
    % XIdata(:, k+1) = -C*Ts*Xdata(:, k) + XIdata(:, k) + Ts*Wdata(:, k) ; % Model/Plant update
    XIdata(:, k+1) = -C*Ts*Xdata(:, k) + XIdata(:, k) ; % Model/Plant update
    Wdata(:, k+1) = Wdata(:, k); % Reference preview
    FLAGdata(:, k) = Flag_k;
end

figure, hold on
set(gcf, 'DefaultLineLineWidth', 10);
set(gcf, ['Default', 'Stair', 'LineWidth'], 10);
for j = 1:nu
    stairs(0:Nsim-1, Udata(j, :), 'b', 'LineWidth', 10)
end
hold on
plot(0:Nsim, zeros(1, Nsim+1), 'r--', 'LineWidth', 10)
hold on
plot(0:Nsim, u_min*ones(1, Nsim+1), 'm-.', 'LineWidth', 10)
hold on
plot(0:Nsim, u_max*ones(1, Nsim+1), 'm-.', 'LineWidth', 10)
% ax = gca;
% ax.FontSize = 20;
set(gca, 'FontSize', 20, 'TickLabelInterpreter','latex')
xlabel('$k$', 'FontSize', 30, 'interpreter', 'latex')
ylabel('$u \ [-]$', 'interpreter','latex','FontSize', 30)
% title('$Riadiaca veličina$','FontSize', 15, 'interpreter', 'latex')
leg = legend('$u$', 'referencia', 'ohranicenia', 'interpreter', 'latex')
set(leg, 'FontSize', 20, 'Location', 'north')
set(leg, 'Orientation', 'horizontal')
% f2p('Akcne_zasahy_sim', 'extension', 'png')
f2p('Akcne_zasahy_sim')

figure, hold on
set(0, 'DefaultLineLineWidth', 10)
set(groot, ['Default', 'Stair', 'LineWidth'], 10)
for j = 1:nx
    stairs(0:Nsim, Xdata(j, :), 'b', 'LineWidth', 10)
end
hold on
plot(0:Nsim, zeros(1, Nsim+1), 'r--', 'LineWidth', 10)
hold on
plot(0:Nsim, x_min*ones(1, Nsim+1), 'm-.', 'LineWidth', 10)
hold on
plot(0:Nsim, x_max*ones(1, Nsim+1), 'm-.', 'LineWidth', 10)
% ax = gca;
% ax.FontSize = 20;
set(gca, 'FontSize', 20, 'TickLabelInterpreter','latex')
% title('$Riadená veličina$','FontSize', 15, 'interpreter', 'latex')
xlabel('$k$', 'FontSize', 30, 'interpreter', 'latex')
ylabel('$x \ [\mathrm{^\circ C}]$', 'interpreter', 'latex','FontSize', 30)
leg = legend('$x$', 'referencia', 'ohranicenia','interpreter', 'latex')
set(leg, 'FontSize', 20, 'Location', 'north')
set(leg, 'Orientation', 'horizontal')
% f2p('Teplota_sim', 'extension', 'png')
f2p('Teplota_sim')



figure, hold on
set(0, 'DefaultLineLineWidth', 10)
set(groot, ['Default', 'Stair', 'LineWidth'], 10)
for j = 1:nx
    stairs(0:Nsim, XIdata(j, :), 'b', 'LineWidth', 10)
end
hold on
plot(0:Nsim, zeros(1, Nsim+1), 'r--', 'LineWidth', 10)
% ax = gca;
% ax.FontSize = 20;
set(gca, 'FontSize', 20, 'TickLabelInterpreter','latex')
xlabel('$k$', 'FontSize', 30, 'interpreter', 'latex')
ylabel('$x \ [\mathrm{^\circ C}]$', 'interpreter', 'latex','FontSize', 30)
leg = legend('$x_{I}$','interpreter', 'latex')
set(leg, 'FontSize', 20, 'Location', 'north')
set(leg, 'Orientation', 'horizontal')
f2p('Integrator_Teplota_sim')