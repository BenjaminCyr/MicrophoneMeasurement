

folder_name = "ADMP05_Final";
results_folder = strcat("./Output/results/", folder_name, "/");
files = dir(results_folder);

out_results_dir = strcat("./Output/results/", folder_name, "_preamp/");
if ~exist(out_results_dir, 'dir')
    mkdir(out_results_dir);
end
out_figs_dir = strcat("./Output/figs/", folder_name, "_preamp/");
if ~exist(out_figs_dir, 'dir')
    mkdir(out_figs_dir);
end
out_pngs_dir = strcat("./Output/pngs/", folder_name, "_preamp/");
if ~exist(out_pngs_dir, 'dir')
    mkdir(out_pngs_dir);
end



for ind = 3:length(files)
    file_name = files(ind).name;
    load(strcat(results_folder, file_name));
    [~, name, ~] = fileparts(file_name);
    out_file = strcat(name, "_preamp");
    
    if isequal(size(amp_out), [100 2])
       amp_out = amp_out(:,1); 
       phase_out = phase_out(:,1);
    end

    in_signal = amp_out'.*exp(1j*phase_out'*pi/180);

    omegas = 2*pi*frequencies;
    Z1s = 1./omegas/1j/4.7e-6 + 1.5e3;
    Z2s = 1./(1/100e3 + 1j*omegas*100e-12);

    out_signal = in_signal.*(-Z1s./Z2s);


    amp_out = abs(out_signal);
    phase_out = angle(out_signal)*180/pi;
    
    
    save(strcat(out_results_dir, out_file, '.mat'), 'frequencies', 'amp_out', 'phase_out');

    figure;
    subplot(2, 1, 1);
    loglog(frequencies, amp_out, 'LineWidth', 3);

    subplot(2, 1, 2);
    semilogx(frequencies, phase_out, 'LineWidth', 3);
    ylim([-180 180]);
    
    fullfig(gcf);
    set(0, 'DefaultAxesFontSize', 14);
    savefig(strcat(out_figs_dir, out_file, '.fig'));
    exportgraphics(gcf,strcat(out_pngs_dir, out_file, '.png'),'Resolution',300) 
    close(gcf);

end



