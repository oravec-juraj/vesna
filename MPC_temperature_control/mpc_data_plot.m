%% mpc_plot_data

load('mpc_data_log')

mpc_data_table
t = mpc_data_table.Time;
T = mpc_data_table.t_val;
u = mpc_data_table.u;
w = mpc_data_table.w;

figure
stairs(t, T)
hold on
stairs(t, w)
grid on
xlim([t(1) t(end)+0.5])
ylim([min(w)-2 max(T)+2])
xlabel('$t$', 'interpreter','latex')
ylabel('$T$, $w$', 'interpreter','latex')
% legend('Teplota', 'Referencia', 'interpreter', 'latex', 'FontSize', 10)
% title('Riadenie teploty a ziadana velicina', 'interpreter', 'latex', 'Fontsize', 10)
hold off
exportgraphics(gcf, 'Teplota_imp.png', 'Resolution', 300)
%%
figure
stairs(t, u)
grid on
xlim([t(1) t(end)+0.5])
ylim([min(u) max(u)+5])
xlabel('$t$', 'interpreter','latex')
ylabel('$u$', 'interpreter','latex')
% title('Akcne zasahy', 'interpreter', 'latex', 'Fontsize', 10)
exportgraphics(gcf, 'Akcne_zasahy_imp.png', 'Resolution', 300)




% aj referencie w
% aj zasahy u
% Vykreslit grafy, spustit vesna_control, pockat na hodnoty, heatM a tuto
% vykreslovat.

%% POSTUP RIADENIA
% MPC_construction.m, potom VESNA control (Vo vesna control momentalne je natvrdo nastavena hodnota referencie.)