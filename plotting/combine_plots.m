close all;


RED = [1 0 0];
GREEN = [0 1 0];
BLUE = [0 0 1];
ORANGE = [1 0.5 0];

DEVICES = ["SPU03", "CMM03", "SPA03", "VM03"];
% FILES = ["SPU03_450nm__1atm_AC", "CMM03_450nm_1atmatm_5mW_AC", "SPA03_450nm_1atmatm_5mW_AC", "VM03_450nm_1atm_5mW_AC"];
% FILES = ["SPU03_450nm_1atm_5mW_AC", "CMM03_450nm_1atm_5mW_AC", "SPA03_450nm_1atm_5mW_AC", "VM03_450nm_1atm_5mW_AC"];
FILES = ["SPU03_450nm_5mW_2mWpp_Pressure", "CMM03_450nm_5mW_2mWpp_Pressure", "SPA03_450nm_5mW_2mWpp_Pressure", "VM03_450nm_5mW_2mWpp_Pressure"];
COEFFICIENTS = [1, 1, 1, 1];
LINES_STYLE_ORDER = {'-', '--', '-.', ':'};
COLOR_ORDER = [RED; GREEN; BLUE; ORANGE];% BLUE];


in_folder = "../Output/figs/";
legend_array = DEVICES;
out_folder = "Combined";
out_file = "CombinedPressureResponseNormalized";

out_fig_path = strcat('../Output/figs/analysis/', out_folder);
if ~exist(out_fig_path, 'dir')
    mkdir(out_fig_path);
end
out_png_path = strcat('../Output/pngs/analysis/', out_folder);
if ~exist(out_png_path, 'dir')
    mkdir(out_png_path);
end

x_datas = [];
y_datas = [];
for i = 1:length(DEVICES)
    fig = openfig(strcat(in_folder, DEVICES(i), "/", FILES(i),'.fig'));
    lines = findall(fig, 'Type', 'Line');
    x_data = reshape([lines.XData], [], 4);
    y_data = reshape([lines.YData], [], 4);
%     phase_out = fig.Children(1).Children.YData;
    x_datas = [x_datas x_data(:,3)*COEFFICIENTS(i)];
    y_datas = [y_datas y_data(:,3)/max(y_data(:,3))];
%     y_datas = [y_datas y_data(:,3)];
    close(fig);
end

figure;

% example = 2000./frequencies;
       
% subplot(2,1,1);
% semilogx(frequencies, amp_outs, 'LineWidth', 2, 'MarkerSize', 5)
% slopes = (log10(amp_outs(:,2:end)) - log10(amp_outs(:,1:end-1)))./(log10((frequencies(:,2:end))) - log10(frequencies(:,1:end-1)));
% slopes = (log10(example(:,2:end)) - log10(example(:,1:end-1)))./(log10((frequencies(:,2:end))) - log10(frequencies(:,1:end-1)));
% semilogx(frequencies(1:end-1), slopes, 'LineWidth', 2, 'MarkerSize', 5);
% semilogx(frequencies, y_data, 'LineWidth', 2, 'MarkerSize', 5);
% x_data = linspace(0.1, 1, length(y_data))';
% y_data = sqrt(x_data);
% x_datas = [x_datas x_data];
% y_datas = [y_datas y_data/max(y_data)];
   
plot(x_datas, y_datas);

ax = gca;
colororder(COLOR_ORDER);
ax.LineStyleOrder = LINES_STYLE_ORDER;
legend(legend_array, 'Location', 'southeast');
title(out_file, 'Interpreter', 'none');

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