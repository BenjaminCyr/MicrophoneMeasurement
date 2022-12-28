
folder = 'C:\Users\SPQRLab\Workspace\MicrophoneMeasurement\VibData\vib_data\';

devices = dir(folder)';
devices = devices(3:end);

figure;

j = 1;
num_frequencies = 195;
out_x = zeros(length(devices), num_frequencies);
out_values = zeros(length(devices), num_frequencies);
out_phase = zeros(length(devices), num_frequencies);
device_names = cell(length(devices),1);
plot_idx = 1;

for device = devices
    disp(device.name)
    device_names{j} = device.name;
    device_folder = append(folder, device.name, "\");
    svd_files = dir(device_folder)';
    svd_files = svd_files(3:end);
    
    

    i = 1;
    for file = svd_files
        if endsWith(file.name, ".svd")
            svd_file = append(device_folder, file.name);
            [x,y,usd] = GetPointData(svd_file, 'FFT', 'Vib Top', 'Displacement', 'Magnitude', 0 , 0);
            y = mean(y, 1);
            freq = split(file.name, ["." "_"]);
            freq = str2double(freq{2});
            idx = find(x>freq, 1);

            min_index = max([idx - 2, 1]);
            max_index = min([idx + 2, length(x)]);
            [max_value, max_idx] = max(y(min_index:max_index));
            max_idx = min_index + max_idx - 1;

            out_x(j,i) = freq;
            out_values(j,i) = max_value;
            
            [x2,y2,usd2] = GetPointData(svd_file, 'FFT', 'Vib Top', 'Displacement', 'Phase', 0 , 0);
            y2 = mean(y2, 1);
            out_phase(j, i) = y2(max_idx);
            i = i + 1;
        end
    end
    
    [out_x(j,:), idx] = sort(out_x(j,:));
    out_values(j,:) = out_values(j, idx);
    out_phase(j,:) = out_phase(j, idx);

    subplot(4, 4, plot_idx);
    plot_idx = plot_idx + 1;
    loglog(out_x(j,:), out_values(j,:));
    title(device.name);

    subplot(4, 4, plot_idx);
    semilogx(out_x(j,:), out_phase(j,:));
    title(device.name);
    plot_idx = plot_idx + 1;
    
    j = j + 1;
end

save('VibrometerOutput.mat', 'device_names', 'out_x', 'out_values', 'out_phase');
