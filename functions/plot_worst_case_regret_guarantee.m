fig_reg_time = figure;

matlab_blue = [0 0.4470 0.7410];
matlab_orange = [0.8500 0.3250 0.0980];

colororder({'k','k'})

yyaxis left 
r1 = plot(N, R, 'o-', 'Color', matlab_blue, 'MarkerFaceColor', matlab_blue);
hold on
grid on
grid minor
r2 = plot(N, R_dr, 'o-', 'Color', matlab_orange, 'MarkerFaceColor', matlab_orange);
ylabel('Worst-case regret bound', 'Interpreter', 'latex', 'FontSize', 14)
ylim([10 25])

yyaxis right
s1 = plot(N, solver_time, 'x-.', 'Color', matlab_blue);
s2 = plot(N, solver_time_dr, 'x-.', 'Color', matlab_orange);
set(gca, 'YScale', 'log')
hold off
ylabel('Computation time [s]', 'Interpreter', 'latex', 'FontSize', 14)

set(gca,'TickLabelInterpreter','latex')
xlabel('$N$', 'Interpreter', 'latex', 'FontSize', 14)

% Produce left-axis legend
legend([r1, r2], '$\bar{\mathtt{R}}^\star_N$', '$\hat{\mathtt{R}}^\star_N$', 'Interpreter', 'latex', 'FontSize', 12, 'Location', 'SouthWest')
% Create invisible axis in the same position as the current axes
ax = gca(); % Handle to the main axes
axisCopy = axes('Position', ax.Position, 'Visible', 'off');
% Copy objects to second axes
hCopy1 = copyobj(s1, axisCopy);
hCopy2 = copyobj(s2, axisCopy);
% Replace all x values with NaN so the line doesn't appear
hCopy1.XData = nan(size(hCopy1.XData)); 
hCopy2.XData = nan(size(hCopy2.XData)); 
% Create right axis legend
legend([hCopy1 hCopy2], '$\bar{\tau}_N$', '$\hat{\tau}_N$', 'Interpreter', 'latex', 'FontSize', 12, 'Location', 'SouthEast')