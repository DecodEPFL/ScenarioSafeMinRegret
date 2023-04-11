fig_regret = figure;
plot(N, R, 'o-', 'Color', 'k', 'MarkerFaceColor', 'k')
grid on
grid minor

set(gca,'TickLabelInterpreter','latex')
xlabel('$N$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\bar{\mathtt{R}}^\star_N$', 'Interpreter', 'latex', 'FontSize', 14)