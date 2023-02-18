close all;


noise_floors = [1e-3 1e-2 1e-2 1e-3 1e-2 1e-2 1e-2 1e-1];
folder = "./Output/results/";
% out_file = "CombinedOutputColor";

% out_file = "CombinedLocation";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_450nm_5mW_2mWpp_1atm" "CMM03_MEMFRONT_Journal/CMM03_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]
%              ["SPU03_Journal/SPU03_Journal_450nm_5mW_2mWpp_1atm"  "SPU03_MEMFRONT_Journal/SPU03_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]
%              ["ICS01_Journal/ICS01_Journal_450nm_5mW_2mWpp_1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_450nm_5mW_2mWpp_1atm" "ADMP02_MEMFRONT_Journal/ADMP02_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]
%              ["SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm" "SPA01_DPKG_MEMFRONT/SPA01_DPKG_MEMFRONT_450nm_5mW_1mWpp_1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_450nm_5mW_2mWpp_1atm" "SPH0641_02_MEMFRONT_Journal/SPH0641_02_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]
%              ["VM04_Journal/VM04_Journal_450nm_5mW_2mWpp_1atm" "VM1010_MEMFRONT_Journal/VM1010_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_450nm_5mW_2mWpp_1atm" "VM3000_02_MEMFRONT_Journal/VM3000_02_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm"]};
         
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_0.1atm"]};

% out_file = "Combined Output Power";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_520nm_1mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_1atm"]
%              ["SPU03_Journal/SPU03_Journal_520nm_1mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_1atm"]
%              ["ICS01_Journal/ICS01_Journal_520nm_1mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_520nm_1mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_1atm"]
%              ["SPA04_Journal/SPA04_Journal_520nm_1mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_520nm_1mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_1atm"]
%              ["VM04_Journal/VM04_Journal_520nm_1mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_520nm_1mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_1atm"]};

% out_file = "Combined Output Pressure";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_520nm_1mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_1mW_2mWpp_0.1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPU03_Journal/SPU03_Journal_520nm_1mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_1mW_2mWpp_0.1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ICS01_Journal/ICS01_Journal_520nm_1mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_1mW_2mWpp_0.1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_520nm_1mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_1mW_2mWpp_0.1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPA04_Journal/SPA04_Journal_520nm_1mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_1mW_2mWpp_0.1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_520nm_1mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_1mW_2mWpp_0.1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM04_Journal/VM04_Journal_520nm_1mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_1mW_2mWpp_0.1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_520nm_1mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_1mW_2mWpp_0.1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_0.1atm"]};

% out_file = "Combined Output Pressure";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_0.1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_0.1atm"]};

% out_file = "CombinedColor";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_450nm_5mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_520nm_5mW_2mWpp_1atm" "CMM03_Journal/CMM03_Journal_638nm_5mW_2mWpp_1atm"]
%              ["SPU03_Journal/SPU03_Journal_450nm_5mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_520nm_5mW_2mWpp_1atm" "SPU03_Journal/SPU03_Journal_638nm_5mW_2mWpp_1atm"]
%              ["ICS01_Journal/ICS01_Journal_450nm_5mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_520nm_5mW_2mWpp_1atm" "ICS01_Journal/ICS01_Journal_638nm_5mW_2mWpp_1atm"]
%              ["ADMP01_Journal/ADMP01_Journal_450nm_5mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_520nm_5mW_2mWpp_1atm" "ADMP01_Journal/ADMP01_Journal_638nm_5mW_2mWpp_1atm"]
%              ["SPA04_Journal/SPA04_Journal_450nm_5mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_520nm_5mW_2mWpp_1atm" "SPA04_Journal/SPA04_Journal_638nm_5mW_2mWpp_1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_450nm_5mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_520nm_5mW_2mWpp_1atm" "SPH0641_01_Journal/SPH0641_01_Journal_638nm_5mW_2mWpp_1atm"]
%              ["VM04_Journal/VM04_Journal_450nm_5mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_520nm_5mW_2mWpp_1atm" "VM04_Journal/VM04_Journal_638nm_5mW_2mWpp_1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_450nm_5mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_520nm_5mW_2mWpp_1atm" "VM3000_01_Journal/VM3000_01_Journal_638nm_5mW_2mWpp_1atm"]};
         
% out_file = "Combined Vibrometer";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_450nm_5mW_2mWpp_1atm", "CMM04_Unpowered_Vib/CMM04_Unpowered_Vib_450nm_5mW_2mWpp_1atm" ]
%              ["SPU03_Journal/SPU03_Journal_450nm_5mW_2mWpp_1atm", "SPU06_Vib/SPU06_Vib_450nm_5mW_2mWpp_1atm"]
%              ["ICS01_Journal/ICS01_Journal_450nm_5mW_2mWpp_1atm", "ICS02_Vib/ICS02_Vib_450nm_5mW_2mWpp_1atm"]
%              ["ADMP02_MEMFRONT_Journal_preamp/ADMP02_MEMFRONT_Journal_450nm_5mW_2mWpp_1atm_preamp", "ADMP05_MEMBACK_Unpowered_Vib/ADMP05_MEMBACK_Unpowered_Vib_450nm_5mW_2mWpp_1atm"]
%              ["SPA04_Journal/SPA04_Journal_450nm_5mW_2mWpp_1atm", "SPA05_Vib/SPA05_Vib_450nm_5mW_2mWpp_1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_450nm_5mW_2mWpp_1atm", "SPH0641_03_Vib/SPH0641_03_Vib_450nm_5mW_2mWpp_1atm"]
%              ["VM04_Journal/VM04_Journal_450nm_5mW_2mWpp_1atm", "VM1010_01_ROTATE_Vib/VM1010_01_ROTATE_Vib_450nm_5mW_2mWpp_1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_450nm_5mW_2mWpp_1atm", "VM3000_03_Vib/VM3000_03_Vib_450nm_5mW_2mWpp_1atm"]};
% 
% out_file = "Combined IR";
% FIG_FILES = {["CMM03_Journal/CMM03_Journal_450nm_5mW_2mWpp_1atm", "CMM04/CMM04_1470nm_5mW_2mWpp_1atm" ]
%              ["SPU03_Journal/SPU03_Journal_450nm_5mW_2mWpp_1atm", "SPU06/SPU06_1470nm_5mW_2mWpp_1atm"]
%              ["ICS01_Journal/ICS01_Journal_450nm_5mW_2mWpp_1atm", "ICS02/ICS02_1470nm_5mW_2mWpp_1atm"]
%              ["ADMP01_Journal_preamp/ADMP01_Journal_450nm_5mW_2mWpp_1atm_preamp", "ADMP04_preamp/ADMP04_1470nm_5mW_2mWpp_1atm_preamp"]
%              ["SPA04_Journal/SPA04_Journal_450nm_5mW_2mWpp_1atm", "SPA04/SPA04_1470nm_5mW_2mWpp_1atm"]
%              ["SPH0641_01_Journal/SPH0641_01_Journal_450nm_5mW_2mWpp_1atm", "SPH0641_03/SPH0641_03_1470nm_5mW_2mWpp_1atm"]
%              ["VM04_Journal/VM04_Journal_450nm_5mW_2mWpp_1atm", "VM1010_04/VM1010_04_1470nm_5mW_2mWpp_1atm"]
%              ["VM3000_01_Journal/VM3000_01_Journal_450nm_5mW_2mWpp_1atm", "VM3000_03/VM3000_03_1470nm_5mW_2mWpp_1atm"]};
% 

out_file = "Combined IR Vib";
FIG_FILES = {["CMM04/CMM04_1470nm_5mW_2mWpp_1atm" "CMM04_Unpowered_Vib/CMM04_Unpowered_Vib_450nm_5mW_2mWpp_1atm"]
             ["SPU06/SPU06_1470nm_5mW_2mWpp_1atm" "SPU06_Vib/SPU06_Vib_450nm_5mW_2mWpp_1atm"]
             ["ICS02/ICS02_1470nm_5mW_2mWpp_1atm" "ICS02_Vib/ICS02_Vib_450nm_5mW_2mWpp_1atm"]
             ["ADMP04_preamp/ADMP04_1470nm_5mW_2mWpp_1atm_preamp" "ADMP05_MEMBACK_Unpowered_Vib/ADMP05_MEMBACK_Unpowered_Vib_450nm_5mW_2mWpp_1atm"]
             ["SPA04/SPA04_1470nm_5mW_2mWpp_1atm" "SPA05_Vib/SPA05_Vib_450nm_5mW_2mWpp_1atm"]
             ["SPH0641_03/SPH0641_03_1470nm_5mW_2mWpp_1atm" "SPH0641_03_Vib/SPH0641_03_Vib_450nm_5mW_2mWpp_1atm"]
             ["VM1010_04/VM1010_04_1470nm_5mW_2mWpp_1atm" "VM1010_01_ROTATE_Vib/VM1010_01_ROTATE_Vib_450nm_5mW_2mWpp_1atm"]
             ["VM3000_03/VM3000_03_1470nm_5mW_2mWpp_1atm" "VM3000_03_Vib/VM3000_03_Vib_450nm_5mW_2mWpp_1atm"]};
titles = ["CMM3526", "SPU0410", "ICS41350", "ADMP401", "SPA1687", "SPH0641", "VM1010", "VM3000"];

% legend_array = {["Packaged" "Unpackaged"]
%                 ["Packaged" "Unpackaged"]
%                 ["Packaged"]
%                 ["Packaged" "Unpackaged"]
%                 ["Packaged" "Unpackaged 0.5mW"]
%                 ["Packaged" "Unpackaged"]
%                 ["Packaged" "Unpackaged"]
%                 ["Packaged" "Unpackaged"]};
            
% legend_array = {["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]
%                 ["1atm" "0.1atm"]};
            
% legend_array = {["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]
%                 ["1mW" "5mW"]};
% 
% legend_array = {["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]
%                 ["1mW 1atm" "5mW 1atm" "1mW 0.1atm" "5mW 0.1atm"]};

% legend_array = {["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]
%                 ["450nm" "1470nm"]};
            
% legend_array = {["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]
%                 ["450nm" "520nm" "638nm"]};

legend_array = {["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]
                ["1470nm" "Vib"]};
         
NORMALIZE = true;
P_VALUE_CUTOFF = 0; %0.987;
num_plots = 2*size(FIG_FILES, 1);


RED = [1 0 0];
BLUE = [0 0 1];
GREEN = [0 0.5 0.2];
BLACK = [0 0 0];
ORANGE = [0.8 0.5 0];
COLOR_ORDER = [BLUE; GREEN]; %BLUE; RED;];% BLUE];
LINES_STYLE_ORDER = {'-', '--', 'o--', ':', 'o:'};


my_fig = figure;
for ind1 = 1:size(FIG_FILES,1)
    x_datas = zeros(100, length(FIG_FILES{ind1}));
    y_datas_mag = zeros(100, length(FIG_FILES{ind1}));
    y_datas_phase = zeros(100, length(FIG_FILES{ind1}));
    
    for ind2 = 1:length(FIG_FILES{ind1})
       
        load(strcat(folder, FIG_FILES{ind1}(ind2),'.mat'))
        if isequal(size(amp_out),[100 2])
            amp_out = amp_out(:,1)';
            phase_out = phase_out(:,1)';
            bad_indices = p_vals(4,:,1) < P_VALUE_CUTOFF;
            scale_factor = 1; %std(amp_out(~bad_indices))/last_std;
%             good_indices = last_good_indices & ~bad_indices;
%             scale_mean = mean(y_datas_mag(good_indices, ind2) - scale_factor*amp_out(good_indices));
        else
            bad_indices = amp_out < noise_floors(ind1);
        end
%         fig = openfig(strcat(folder, FIG_FILES{ind1}(ind2),'.fig'));
%         lines = findall(fig, 'Type', 'Line');
%         x_datas(:, ind2) = lines.XData;
%         y_datas_phase(:, ind2) = lines(1).YData;
          good_freqs = frequencies(~bad_indices);
          good_amp_out = amp_out(~bad_indices);
          good_phase_out = phase_out(~bad_indices);
          x_datas(1:numel(good_freqs),ind2) = good_freqs;
          y_datas_phase(1:numel(good_freqs), ind2) = good_phase_out;
%         y_datas_phase(:, ind2) = unwrap(lines(1).YData*pi/180)*180/pi;
%         x_data = reshape([lines.XData], [], 4);
%         y_data = reshape([lines.YData], [], 4);
    %     phase_out = fig.Children(1).Children.YData;
%         y_datas_phase(:, ind2) = wrapToPi(smoothdata(unwrap(lines(1).YData*pi/180)))*180/pi;
        
        if NORMALIZE == true
%             y_datas_mag(:, ind2) = lines(2).YData/max(lines(1).YData);
              y_datas_mag(:, ind2) = amp_out/max(amp_out);
        else
%             y_datas_mag(:, ind2) = lines(2).YData;
              y_datas_mag(1:numel(good_freqs), ind2) = good_amp_out;
        end
        
%         low_values_ind = lines(2).YData < noise_floors(ind1);
%         y_datas_mag(bad_indices, ind2) = Inf;
%         x_datas(bad_indices, ind2) = Inf;
%         y_datas_phase(bad_indices, ind2) = Inf;
        
%         last_std = std(y_datas_mag(~bad_indices, ind2));
%         last_good_indices = ~bad_indices;
                
%         close(fig);
    end
%     subplot_tight(2*ceil(size(FIG_FILES, 1)/4), 4, floor((ind1 - 1)/4)*8 + mod((ind1-1), 4) + 1);
    if ind1 < 5
        subplot('Position', [0.25*(ind1-1)+0.03 0.75 0.21 0.21]);
    else
        subplot('Position', [0.25*(ind1-5)+0.03 0.26 0.21 0.21]);
    end
    
%     set(my_fig,'defaultAxesColorOrder',[BLACK; BLACK]);
    
    loglog(x_datas(:,1), y_datas_mag(:,1), 'LineWidth', 3);
    hold on;
    ax = gca;
    colororder(COLOR_ORDER);
    ax.LineStyleOrder = LINES_STYLE_ORDER;
    ylabel('Amplitude (mV)');
    ylim([1e-2 1e3]);
    yticks([1e-1 1e0 1e1 1e2 1e3]);
    
%     yyaxis right;
    loglog(x_datas(1:numel(good_freqs),1), y_datas_mag(1:numel(good_freqs),2), 'LineWidth', 3);
%     ylim([1e-2*scale_factor 1e3*scale_factor]);
%     ylabel('Displacement (nm)');

    xlim([10 100000]);
    ax = gca;
    colororder(COLOR_ORDER);
    ax.LineStyleOrder = LINES_STYLE_ORDER;
    legend(legend_array{ind1}, 'Location', 'south');
    title(titles(ind1), 'Interpreter', 'none');
    
    xticklabels(ax, {});
    
%     subplot_tight(2*ceil(size(FIG_FILES, 1)/4), 4, floor((ind1 - 1)/4)*8 + mod((ind1-1), 4) + 5);
    if ind1 < 5
        subplot('Position', [0.25*(ind1-1)+0.03 0.54 0.21 0.21]);
    else
        subplot('Position', [0.25*(ind1-5)+0.03 0.05 0.21 0.21]);
    end
    semilogx(x_datas, y_datas_phase, 'LineWidth', 3, 'MarkerSize', 8, 'MarkerIndices', 1:5:length(x_datas));
    ylim([-180 180]);
    yticks([-180 -135 -90 -45 0 45 90 135 180]);
    xlim([10 100000]);
    ax = gca;
    colororder(COLOR_ORDER);
    ax.LineStyleOrder = LINES_STYLE_ORDER;
    legend(legend_array{ind1}, 'Location', 'south');
    ylabel(['Phase (' char(176) ')']);
    xlabel('Frequency (Hz)');
    save(append(titles(ind1), ".mat"), 'x_datas', 'y_datas_mag', 'y_datas_phase');
end


fullfig(gcf);
set(0, 'DefaultAxesFontSize', 14);
savefig(strcat('./Output/figs/analysis/', out_file, '.fig'));
exportgraphics(gcf,strcat('./Output/pngs/analysis/', out_file, '.png'),'Resolution',300) 
