fig_prob = figure;

matlab_blue = [0 0.4470 0.7410];
matlab_orange = [0.8500 0.3250 0.0980];

semilogy(N, violations/validation_samples, 'o-', 'Color', matlab_blue, 'MarkerFaceColor', matlab_blue)
grid on
grid minor
hold on
plot(N, violations_dr/validation_samples, 'o-', 'Color', matlab_orange, 'MarkerFaceColor', matlab_orange)
% Plot the theoretical upper bounds
fill([N(15:end), fliplr(N(15:end))], [epsilons, ones(1, length(epsilons))], matlab_blue, 'FaceAlpha', 0.1, 'LineStyle', 'none')
fill([N(6:end), fliplr(N(6:end))], [epsilons_dr, [fliplr(epsilons) ones(1, length(epsilons_dr) - length(epsilons))]], matlab_orange, 'FaceAlpha', 0.1, 'LineStyle', 'none')
plot(N(15:end), epsilons, '--', 'Color', 'k')
plot(N(6:end), epsilons_dr, '--', 'Color', 'k')

set(gca,'TickLabelInterpreter','latex')
xlabel('$N$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('Violation probability', 'Interpreter', 'latex', 'FontSize', 14)

legend('Empirical estimate $\bar{V}_N$', 'Empirical estimate $\widehat{V}_N$', 'Theoretical upper bound on $\bar{V}_N$', 'Theoretical upper bound on $\widehat{V}_N$', 'Interpreter', 'latex', 'FontSize', 12)