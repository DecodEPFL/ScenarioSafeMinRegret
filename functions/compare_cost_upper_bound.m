fig_upperbounds = figure;
HR = objective_inf_robust^2*ones(considered_dynamics, 1) - objective_reg_robust*ones(considered_dynamics, 1);

hold on 
plot(1:considered_dynamics, cost_psi_gaussian(1, :)', 'o', 'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410])
plot(1:considered_dynamics, cost_psi_uniform(1, :)', 'o', 'Color', [0.8500 0.3250 0.0980], 'MarkerFaceColor', [0.8500 0.3250 0.0980])
for i = 2:5
    plot(1:considered_dynamics, cost_psi_gaussian(i, :)', 'o', 'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410], 'HandleVisibility','off')
    plot(1:considered_dynamics, cost_psi_uniform(i, :)', 'o', 'Color', [0.8500 0.3250 0.0980], 'MarkerFaceColor', [0.8500 0.3250 0.0980], 'HandleVisibility','off')
end
plot(1:considered_dynamics, cost_psi_ramp', 'o', 'Color', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250])
plot(1:considered_dynamics, cost_psi_constant', 'o', 'Color', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560])
plot(1:considered_dynamics, cost_psi_stairs', 'o', 'Color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880])
plot(1:considered_dynamics, cost_psi_worst - 3, 'o', 'Color', [0.3010 0.7450 0.9330], 'MarkerFaceColor', [0.3010 0.7450 0.9330])

fill([1:considered_dynamics, fliplr(1:considered_dynamics)], [zeros(1, considered_dynamics), HR'], 'g', 'FaceAlpha', 0.03, 'LineStyle', 'none', 'HandleVisibility','off')
fill([1:considered_dynamics, fliplr(1:considered_dynamics)], [HR', 5.5*ones(1, considered_dynamics)], 'r', 'FaceAlpha', 0.03, 'LineStyle', 'none', 'HandleVisibility','off')

grid on
grid minor

yline(HR(1), '--k', 'Alpha', 0.75, 'LineWidth', 0.75)

xlim([1 considered_dynamics])
ylim([0 5.5])

set(gca,'TickLabelInterpreter','latex', 'XMinorGrid', 0)
lgnd = legend('Gaussian','Uniform', 'Ramp', 'Constant', 'Stairs', 'Worst', 'Interpreter', 'latex', 'FontSize', 12, 'Orientation','horizontal')
set(lgnd,'color','none');
xticks([1:20])
xticklabels([])

yticks([0:0.5:5])
yticklabels({'0','0.5', '1', '1.5', '2', '2.5', '3', '\vdots', '7', '7.5', '8', '8.5'})

for ii = 1:considered_dynamics
    xline(ii, '--k', 'HandleVisibility','off', 'Alpha', 0.25)
end

xlabel('Uncertain system realizations', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('Clairvoyant optimal cost', 'Interpreter', 'latex', 'FontSize', 14)

box on

text(15,2.7,'$\bar{\mathtt{H}}^\star_N - \bar{\mathtt{R}}^\star_N$', 'Interpreter', 'latex', 'FontSize', 12)