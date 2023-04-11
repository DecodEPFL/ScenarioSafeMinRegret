fig_prob = figure;
plot(N, violations/validation_samples, 'o-', 'Color', 'k', 'MarkerFaceColor', 'k')
grid on
grid minor
hold on
plot(N(15:end), epsilons, 'o', 'Color', 'k', 'MarkerFaceColor', 'k')

fill([N(15:end), fliplr(N(15:end))], [epsilons, ones(1, length(epsilons))], 'k', 'FaceAlpha', 0.1, 'LineStyle', 'none')
set(gca,'TickLabelInterpreter','latex')
xlabel('$N$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\widehat{V}$', 'Interpreter', 'latex', 'FontSize', 14)

legend('Empirical violation probability','Theoretical upper bound', 'Interpreter', 'latex', 'FontSize', 12)