fig_comparison = figure;

plot(1:considered_dynamics, -100*avg_gap_gaussian, 'o', 'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410])
grid on
grid minor
hold on
plot(1:considered_dynamics, -100*avg_gap_uniform, 'o', 'Color', [0.8500 0.3250 0.0980], 'MarkerFaceColor', [0.8500 0.3250 0.0980])
plot(1:considered_dynamics, -100*avg_gap_ramp, 'o', 'Color', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250])
plot(1:considered_dynamics, -100*avg_gap_constant, 'o', 'Color', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560])
plot(1:considered_dynamics, -100*avg_gap_stairs, 'o', 'Color', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880])
plot(1:considered_dynamics, 100*avg_gap_worst, 'o', 'Color', [0.3010 0.7450 0.9330], 'MarkerFaceColor', [0.3010 0.7450 0.9330])

fill([0:considered_dynamics, fliplr(0:considered_dynamics)], [zeros(1, considered_dynamics+1), 10*ones(1, considered_dynamics+1)], 'g', 'FaceAlpha', 0.03, 'LineStyle', 'none')
fill([0:considered_dynamics, fliplr(0:considered_dynamics)], [zeros(1, considered_dynamics+1), -10*ones(1, considered_dynamics+1)], 'r', 'FaceAlpha', 0.03, 'LineStyle', 'none')

xlim([1 considered_dynamics])
ylim([-6 10])

set(gca,'TickLabelInterpreter','latex', 'XMinorGrid', 0)
lgnd = legend('Gaussian','Uniform', 'Ramp', 'Constant', 'Stairs', 'Worst', 'Interpreter', 'latex', 'FontSize', 12, 'Orientation','horizontal')
set(lgnd,'color','none');
xticks([1:20])
xticklabels([])

yticks([-6 -4 -2 0 2 4 6 8 10])
yticklabels({'-6\%', '-4\%', '-2\%', '0\%', '2\%', '4\%', '6\%', '8\%', '10\%'})

for ii = 1:considered_dynamics
    xline(ii, '--k', 'HandleVisibility','off', 'Alpha', 0.25)
end

xlabel('Uncertain system realizations', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\Delta \bar{J}$', 'Interpreter', 'latex', 'FontSize', 14)