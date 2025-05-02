%% MODEL DATA - TEMPERATURE
Z_heat = 0.0127; % system gain
T_heat = 13.0164*20; % time constant

% Continuous state-space system
Ac_heat = [-1/T_heat];
Bc_heat = [Z_heat/T_heat];
Cc_heat = [1];
Dc_heat = [0];
sysC_heat = ss(Ac_heat, Bc_heat, Cc_heat, Dc_heat);

%Discrete-time state-space system
Ts = 60; % Sampling time
sysD_heat = c2d(sysC_heat, Ts);
[A_heat, B_heat, C_heat, D_heat] = ssdata(sysD_heat);

% Problem size
nx_heat = size(A_heat,1); % Number of states
% Problem size
nx_heat = size(A_heat,1); % Number of states
nu_heat = size(B_heat,2); % Number of inputs
ny_heat = size(C_heat,1); % Number of outputs

At_heat = [A_heat, zeros(nx_heat); -C_heat*Ts, eye(ny_heat)];
Bt_heat = [B_heat*10; zeros(nu_heat)];
St_heat = [zeros(ny_heat); Ts*eye(ny_heat)];

Q_heat = eye( nx_heat )*1000;
Qi_heat = eye( ny_heat )*10000;
R_heat = eye( nu_heat )*15;

global XI_heat
XI_heat = 0;
%% MODEL DATA - HUMIDITY
Z_humid = 0.3616; % system gain
T_humid = 235; % time constant

% Continuous state-space system
Ac_humid = [-1/T_humid];
Bc_humid = [Z_humid/T_humid];
Cc_humid = [1];
Dc_humid = [0];
sysC_humid = ss(Ac_humid, Bc_humid, Cc_humid, Dc_humid);

%Discrete-time state-space system
Ts = 60; % Sampling time
sysD_humid = c2d(sysC_humid, Ts);
[A_humid, B_humid, C_humid, D_humid] = ssdata(sysD_humid);

% Problem size
nx_humid = size(A_humid,1); % Number of states
% Problem size
nx_humid = size(A_humid,1); % Number of states
nu_humid = size(B_humid,2); % Number of inputs
ny_humid = size(C_humid,1); % Number of outputs

At_humid = [A_humid, zeros(nx_humid); -C_humid*Ts, eye(ny_humid)];
Bt_humid = [B_humid*10; zeros(nu_humid)];
St_humid = [zeros(ny_humid); Ts*eye(ny_humid)];

Q_humid = eye( nx_humid )*1;
Qi_humid = eye( ny_humid )*100;
R_humid = eye( nu_humid )*15;

global XI_humid
XI_humid = 0;
%% TUBE MPC DESIGN
% LTI system
model = ULTISystem('A', [At_heat, zeros(size(At_heat)); zeros(size(At_humid)), At_humid], 'B', [Bt_heat, zeros(size(Bt_heat)); zeros(size(Bt_humid)), Bt_humid], 'E', eye(4));
model.u.min = [-128;-13];
model.u.max = [ 128; 13];
model.x.min = [-10; -inf; -20; -inf]; 
model.x.max = [ 10; inf; 30; inf];
model.d.min = [-1; -0.1; -1; -1]; 
model.d.max = [ 1; 0.1; 1; 1];
% Penalty functions
model.x.penalty = QuadFunction(diag([Q_heat, Qi_heat, Q_humid, Qi_humid]));
model.u.penalty = QuadFunction(diag([R_heat, R_humid]));
% Prediction horizon
N = 50;
option = {'soltype',1,'LQRstability',1, 'TubeType', 'implicit'}
% Construct Tube MPC controller
global iMPC
iMPC = TMPCController(model,N,option)
x0 = [ -2; 0; -15; 0]; % Initial condition
u = iMPC.evaluate(x0) % Tube MPC evaluation
[ u, feasible ] = iMPC.evaluate(x0) % Feasibility check
%%
%%
% Closed-loop simulation
% Note, function ".simulate" works for the "ClosedLoop" object only if solType == 1
TMPC = iMPC % Implicit Tube MPC
% TMPC = eMPC % Explicit Tube MPC
Nsim = 30; % Number of simulation steps
% Closed-loop data of Tube MPC 
ClosedLoopData = TMPC.simulate(x0, Nsim) 
% Closed-loop data of Tube MPC for any model
closed_loop_object = ClosedLoop(TMPC, model) 
ClosedLoopData = closed_loop_object.simulate(x0, Nsim) 
% Show results
figure(),hold on, box on, grid on, xlabel('Control steps k'), ylabel('System states x(k)')
stairs([0,Nsim],[0;0],'k--')
stairs([0:Nsim],ClosedLoopData.X(1,:))
stairs([0:Nsim],ClosedLoopData.X(3,:))
figure(),hold on, box on, grid on, xlabel('Control steps k'), ylabel('Control inputs u(k)')
stairs([0:Nsim-1],ClosedLoopData.U(1,:))
stairs([0:Nsim-1],ClosedLoopData.U(2,:))
%% FIGURE: Closed-loop Tube MPC
figure()
% System state x1
subplot(3,2,1), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('System state $x_{\mathrm{heat}}(k)$', 'Interpreter','latex', 'FontSize', 15, 'Rotation',0), title('$\textbf{Closed-loop Tube MPC}$', 'FontSize', 15, 'Interpreter','latex')
stairs([0:Nsim],ClosedLoopData.X(1,:), 'LineWidth', 2)
stairs([0,Nsim],[0;0],'k:', 'LineWidth', 2)
stairs([0,Nsim],[model.x.min(1);model.x.min(1)],'k--', 'LineWidth', 2)
stairs([0,Nsim],[model.x.max(1);model.x.max(1)],'k-.', 'LineWidth', 2)
legend('$T$','$w$', '$T_{\mathrm{min}}$','$T_{\mathrm{max}}$','Location','Best', 'interpreter', 'latex', 'FontSize', 10)
axis([0, Nsim, model.x.min(1)-1, model.x.max(1)+1])
% system state x2
subplot(3,2,2), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('System state $x_{\mathrm{humid}}(k)$', 'Interpreter','latex', 'FontSize', 10, 'Rotation',0), title('$\textbf{Closed-loop Tube MPC}$', 'FontSize', 10, 'Interpreter','latex')
stairs([0:Nsim],ClosedLoopData.X(3,:), 'LineWidth', 2)
stairs([0,Nsim],[0;0],'k:', 'LineWidth', 2)
stairs([0,Nsim],[model.x.min(3);model.x.min(3)],'k--', 'LineWidth', 2)
stairs([0,Nsim],[model.x.max(3);model.x.max(3)],'k-.', 'LineWidth', 2)
legend('$H$','$w$', '$H_{\mathrm{min}}$','$H_{\mathrm{max}}$','Location','Best', 'interpreter', 'latex', 'FontSize', 10)
axis([0, Nsim, model.x.min(3)-1, model.x.max(3)+1])
% System state integrators
subplot(3,2,3), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('Integrator $x_{\mathrm{I,heat}}(k)$', 'Interpreter','latex', 'FontSize', 10, 'Rotation',0)
stairs([0:Nsim],ClosedLoopData.X(2,:), 'LineWidth', 2)
stairs([0,Nsim],[0;0],'k:', 'LineWidth', 2)
axis([0, Nsim, model.x.min(2)-0.5, model.x.max(2)+0.5])
% System state integrators
subplot(3,2,4), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('Integrator $x_{\mathrm{I,humid}}(k)$', 'Interpreter','latex', 'FontSize', 10, 'Rotation',0)
stairs([0:Nsim],ClosedLoopData.X(4,:), 'LineWidth', 2)
stairs([0,Nsim],[0;0],'k:', 'LineWidth', 2)
axis([0, Nsim, model.x.min(4)-0.5, model.x.max(4)+0.5])
% Control input1
subplot(3,2,5), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('Control heater inputs $u(k)$', 'Interpreter','latex', 'FontSize', 10, 'Rotation',0)
stairs([0:Nsim-1],ClosedLoopData.U(1,:), 'LineWidth', 2)
stairs([0,Nsim-1],[model.u.min(1);model.u.min(1)],'k--', 'LineWidth', 2)
stairs([0,Nsim-1],[model.u.max(1);model.u.max(1)],'k-.', 'LineWidth', 2)
legend('u','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$','Location','SouthWest', 'Interpreter', 'latex', 'FontSize', 10)
% Control input1
subplot(3,2,6), hold on, box on, grid on 
xlabel('Control steps $k$', 'Interpreter','latex', 'FontSize', 10), ylabel('Control humidiser inputs $u(k)$', 'Interpreter','latex', 'FontSize', 10, 'Rotation',0)
stairs([0:Nsim-1],ClosedLoopData.U(2,:), 'LineWidth', 2)
stairs([0,Nsim-1],[model.u.min(2);model.u.min(2)],'k--', 'LineWidth', 2)
stairs([0,Nsim-1],[model.u.max(2);model.u.max(2)],'k-.', 'LineWidth', 2)
legend('u','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$','Location','SouthWest', 'Interpreter', 'latex', 'FontSize', 10)