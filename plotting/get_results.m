% fig = openfig(strcat('Output/figs/','ADMP01_638nm_5mW_1mWpp_1atm','.fig'));
% amp_out = fig.Children(2).Children.YData;
% phase_out = fig.Children(1).Children.YData;
% save('./Output/results/ADMP01_638nm_5mW_1mWpp_1atm.mat', 'amp_out', 'phase_out', 'frequencies')
out_fig_path = strcat('../Output/figs/analysis/', out_folder);
if ~exist(out_fig_path, 'dir')
    mkdir(out_fig_path);
end
out_png_path = strcat('../Output/pngs/analysis/', out_folder);
if ~exist(out_png_path, 'dir')
    mkdir(out_png_path);
end



frequencies = logspace(log10(20),log10(30000), NUM_FREQS);

num_combined = ~isempty(COMBINE_OUTPUTS);
num_plots = length(DEVICES)*length(LIGHT_FREQUENCIES)*length(DC_POWERS)*...
    length(AC_POWERS)*length(PRESSURES)+ numel(CUSTOM_FILES)/2 + num_combined;
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
                    
                    load(strcat(in_folder,'/', dev, '/', data_name,'.mat'))

                    amp_outs(i,:) = amp_out*OUT_COEFFICIENTS(i);
                    phase_outs(i,:) = phase_out;
                    
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
    load(strcat(in_folder,'/',CUSTOM_FILES(ind,1), '/', CUSTOM_FILES(ind,2),'.mat'))
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


