close all;


folder = "./Output/results";
out_file = "SPU_10X_LowPower";
DEVICES = ["SPU_10X" "SPU_10X_0.8V" "SPU_10X_1V"];%, "SPU02_2_DPKG_MEMFRONT"];%, "ADMP01_DPKG_MEMFRONT"];
CUSTOM_FILES = [];
%                 "SPU03_DPKG_MEMBACK", "SPU03_DPKG_MEMBACK_520nm_0.1mW_1mWpp_1atm";
%                 "SPU03_DPKG_MEMBACK_Unfocused", "SPU03_DPKG_MEMBACK_Unfocused_520nm_0.1mW_2mWpp_1atm"];

OUT_COEFFICIENTS = []; % To account for Vpp vs mV Amplitude
LIGHT_FREQUENCIES = ["520nm"];
DC_POWERS = ["0.1mW" "5mW"];
AC_POWERS = ["2mWpp"];
PRESSURES = ["1atm"];

NUM_FREQS = 100;
COMBINE_OUTPUTS = [];% ["SPU02_DPKG_MEMFRONT", "SPU02_DPKG_ASICTOP_450nm_5mW_0.33mWpp_1atm"];%["VM02_DPKG_MEMFRONT","VM02_DPKG_ASICTOP"];
COMBINE_COEFFICIENTS = [-6*ones(1, NUM_FREQS); zeros(1, NUM_FREQS); ones(1, NUM_FREQS)];%logspace(log10(10), log10(0.01),NUM_FREQS)];

% fig = openfig(strcat('Output/figs/','ADMP01_638nm_5mW_1mWpp_1atm','.fig'));
% amp_out = fig.Children(2).Children.YData;
% phase_out = fig.Children(1).Children.YData;
% save('./Output/results/ADMP01_638nm_5mW_1mWpp_1atm.mat', 'amp_out', 'phase_out', 'frequencies')


RED = [1 0 0];
BLUE = [0 0 1];
GREEN = [0 0.8 0.2];
BLACK = [0 0 0];
COLOR_ORDER = [BLUE; RED;];% BLUE];
LINES_STYLE_ORDER = {'-', 'x-', '--', 'x--', 'x--', '--', 'o:', 'x:',  ':'};



frequencies = logspace(log10(20),log10(30000), NUM_FREQS);

num_combined = ~isempty(COMBINE_OUTPUTS);
num_plots = length(DEVICES)*length(LIGHT_FREQUENCIES)*length(DC_POWERS)*...
    length(AC_POWERS)*length(PRESSURES)+length(CUSTOM_FILES)+ num_combined;
legend_array = cell(1, num_plots);
amp_outs = zeros(num_plots, NUM_FREQS);
phase_outs = zeros(num_plots, NUM_FREQS);

if isempty(OUT_COEFFICIENTS)
    OUT_COEFFICIENTS = ones(1, num_plots);
end

if ~isempty(COMBINE_OUTPUTS)
    combine_complex = zeros(1, NUM_FREQS);
    k = 1;
end

i = 1;
for dev = DEVICES
    for pressure = PRESSURES
        for dc_power = DC_POWERS
            for ac_power = AC_POWERS
                for light_freq = LIGHT_FREQUENCIES
                    data_name = join([dev light_freq dc_power ac_power pressure], '_');
                    legend_array{i} = replace(data_name, '_', ' ');
                    
                    load(strcat(folder,'/', dev, '/', data_name,'.mat'))

                    amp_outs(i,:) = amp_out*OUT_COEFFICIENTS(i);
                    phase_outs(i,:) = phase_out; %phase_out;
                    
                    if ~isempty(COMBINE_OUTPUTS) && ismember(dev, COMBINE_OUTPUTS)
                        complex_vals = COMBINE_COEFFICIENTS(k,:).*amp_outs(i,:).*exp(1j*deg2rad(phase_out));
                        combine_complex = combine_complex + complex_vals;
                        k = k + 1;
                    end
                    i = i + 1;
                end
            end
        end
    end
    
end

for ind = 1:size(CUSTOM_FILES,1)
    legend_array{i} = replace(CUSTOM_FILES(ind,2), '_', ' ');
    load(strcat(folder,'/',CUSTOM_FILES(ind,1), '/', CUSTOM_FILES(ind,2),'.mat'))
    amp_outs(i,:) = amp_out*OUT_COEFFICIENTS(i);
    phase_outs(i,:) = phase_out;
    
    if ~isempty(COMBINE_OUTPUTS) && ismember(custom_file, COMBINE_OUTPUTS)
        complex_vals = COMBINE_COEFFICIENTS(k,:).*amp_outs(i,:).*exp(1j*deg2rad(phase_out));
        combine_complex = combine_complex + complex_vals;
        k = k + 1;
    end
                    
    i = i + 1;
end

if ~isempty(COMBINE_OUTPUTS)
    legend_array{i} = "Combined Output";
    amp_outs(i,:) = abs(combine_complex);
    phase_outs(i,:) = angle(combine_complex)*180/pi;
    i = i + 1;
end

figure;
       
subplot(2,1,1);
loglog(frequencies, amp_outs, 'LineWidth', 1, 'MarkerSize', 5);

ax = gca;
colororder(COLOR_ORDER);
ax.LineStyleOrder = LINES_STYLE_ORDER;
legend(legend_array, 'Location', 'southwest');
title(out_file, 'Interpreter', 'none');

subplot(2,1,2);
semilogx(frequencies, phase_outs, 'LineWidth', 1, 'MarkerSize', 5);
ylim([-180 180]);

ax = gca;
ax.LineStyleOrder = LINES_STYLE_ORDER;
% legend(legend_array, 'Location', 'northeast');

fullfig(gcf);
set(0, 'DefaultAxesFontSize', 14);
savefig(strcat('./Output/figs/analysis/', out_file, '.fig'));
exportgraphics(gcf,strcat('./Output/pngs/analysis/', out_file, '.png'),'Resolution',300) 
