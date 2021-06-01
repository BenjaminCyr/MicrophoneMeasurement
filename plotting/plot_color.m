close all;

RED = [1 0 0];
GREEN = [0 1 0];
BLUE = [0 0 1];
ORANGE = [1 0.5 0];



in_folder = "../Output/results";
out_folder = "Combined";
out_file = "CombinedColorComparisonLog";
DEVICES = ["SPU03", "CMM03", "VM03", "SPA04"];%, "SPU02_2_DPKG_MEMFRONT"];%, "ADMP01_DPKG_MEMFRONT"];
CUSTOM_FILES = [];

OUT_COEFFICIENTS = []; % To account for Vpp vs mV Amplitude
LIGHT_FREQUENCIES = ["450nm", "520nm", "638nm"];
COLOR_ORDER = [BLUE; GREEN; RED];% BLUE];
DC_POWERS = ["5mW"];
AC_POWERS = ["2mWpp"];
PRESSURES = ["1atm"];

NUM_FREQS = 100;
COMBINE_OUTPUTS = [];% ["SPU02_DPKG_MEMFRONT", "SPU02_DPKG_ASICTOP_450nm_5mW_0.33mWpp_1atm"];%["VM02_DPKG_MEMFRONT","VM02_DPKG_ASICTOP"];
COMBINE_COEFFICIENTS = [ones(1,NUM_FREQS); logspace(log10(10), log10(0.01),NUM_FREQS)];

LINES_STYLE_ORDER = {'-', '--', '-.', ':'};


get_results;

%To get colors right:
% amp_outs = [amp_outs(1:2:end,:); amp_outs(2:2:end, :)];
% phase_outs = [phase_outs(1:2:end,:); phase_outs(2:2:end, :)];
% legend_array = [legend_array(1:2:end) legend_array(2:2:end)];

figure;

% example = 2000./frequencies;
       
% subplot(2,1,1);
% semilogx(frequencies, amp_outs, 'LineWidth', 2, 'MarkerSize', 5)
% slopes = (log10(amp_outs(:,2:end)) - log10(amp_outs(:,1:end-1)))./(log10((frequencies(:,2:end))) - log10(frequencies(:,1:end-1)));
% slopes = (log10(example(:,2:end)) - log10(example(:,1:end-1)))./(log10((frequencies(:,2:end))) - log10(frequencies(:,1:end-1)));
% semilogx(frequencies(1:end-1), slopes, 'LineWidth', 2, 'MarkerSize', 5);
% loglog(frequencies, amp_outs, 'LineWidth', 2, 'MarkerSize', 5);
% 
% ax = gca;
% colororder(COLOR_ORDER);
% ax.LineStyleOrder = LINES_STYLE_ORDER;
% legend(legend_array, 'Location', 'northeast');
% title(out_file, 'Interpreter', 'none');

for i = 1:4
    ax = subplot(2, 2, i);
    loglog(frequencies, amp_outs(3*i-2:3*i, :), 'LineWidth', 2, 'MarkerSize', 5);
%     ax = gca;
%     colororder(COLOR_ORDER(i,:));
    ax.LineStyleOrder = LINES_STYLE_ORDER;
    legend(legend_array(3*i-2:3*i), 'Location', 'southwest');
    title(DEVICES(i), 'Interpreter', 'none');
end

% subplot(2,1,2);
% semilogx(frequencies, phase_outs, 'LineWidth', 1, 'MarkerSize', 5);
% % ylim([-180 180]);
% 
% ax = gca;
% ax.LineStyleOrder = LINES_STYLE_ORDER;
% legend(legend_array, 'Location', 'northeast');

fullfig(gcf);
set(0, 'DefaultAxesFontSize', 14);
savefig(strcat('../Output/figs/analysis/', out_folder, "/", out_file, '.fig'));
exportgraphics(gcf,strcat('../Output/pngs/analysis/',out_folder, "/", out_file, '.png'),'Resolution',300) 