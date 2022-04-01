close all;
addpath("./Inc");
%% Device Configuration
PS5000aConfig;

% create our clean up object
% cleanupObj = onCleanup(@cleanMeUp);

SAVE_DATA = true;
LOW_PASS_FILTER = false;
NUM_SAVED_FILES = 5;
WAIT_FOR_USER = true;
FLIPB = true;

DEVICE = "VM3000_01_Journal";
LIGHT_WAVELENGTH = "520nm";

%[0.5 1 1.5 2 3 4 5]
%[0.925 0.964 1 1.048 1.126 1.202 1.280]
% 450nm
% AMPLITUDE_1MW = 0.090;
% DC_2MW = 1.092;
% DC_5MW = 1.364;
% DC_2MW = 0.6;
% DC_5MW = 0.6;
% AMPLITUDE_1MW = 0.045;
% DC_0_1MW = 0.432;
% DC_2MW = 0.542;
% DC_5MW = 0.678;

%520nm
AMPLITUDE_1MW = 0.090;
DC_0_5MW = 0.818;
DC_1MW = 0.878;
DC_2MW = 0.972;
DC_5MW = 1.246;

%638nm
% AMPLITUDE_1MW = 0.076;
% DC_2MW = 2.772;
% DC_5MW = 3.004;



%Frequency RESPONSE
% PRESSURES = [1];
% AMPLITUDES = [AMPLITUDE_1MW AMPLITUDE_1MW]; % 2*AMPLITUDE_1MW];
% OFFSETS = [DC_0_1MW DC_5MW]; % DC_5MW];
% LABELS = ["0.1mW_2mWpp" "5mW_2mWpp"]; %, "5mW_2mWpp"];


%AC RESPONSE
% PRESSURES = [1];
% AMP_MW = 0.5:0.25:5;
% AMPLITUDES = 2*AMP_MW*AMPLITUDE_1MW;
% OFFSETS = DC_5MW*ones(1, length(AMPLITUDES));
% LABELS = "5mW_" + 2*AMP_MW + "mWpp";

%DC RESPONSE
PRESSURES = [0.2];
% DC_MW = [0];
% OFFSETS = [0];
DC_MW = [0.5 1 2 5];
OFFSETS = [DC_0_5MW DC_1MW DC_2MW DC_5MW];
AMPLITUDES = AMPLITUDE_1MW*ones(1, length(OFFSETS));
LABELS = DC_MW + "mW_2mWpp";

%PRESSURE RESPONSE
% WAIT_FOR_USER = true;
% PRESSURES = 0.1:0.1:1;
% AMPLITUDES = 2*AMPLITUDE_1MW*ones(1, length(PRESSURES));
% OFFSETS = DC_5MW*ones(1, length(PRESSURES));
% LABELS = repmat("5mW_2mWpp", 1, length(PRESSURES));

% AMPLITUDES = [0.078 0.156 0.156];
% OFFSETS = [2.662 2.738 2.974];
% LABELS = "5mW_" + AMP_MW + "mWpp";


% AMPLITUDES = [0.074 0.049 0.148 0.049 0.148 0.049];
% OFFSETS = [0.970 0.970 1.044 1.044 1.266 1.266];
% AMPLITUDES = [0.080 0.053 0.160 0.053 0.160 0.053];
% OFFSETS = [2.616 2.616 2.69 2.69 2.926 2.926];
% LABELS = ["1mW_0.5mWpp","1mW_0.33mWpp","2mW_1mWpp", "2mW_0.33mWpp","5mW_1mWpp", "5mW_0.33mWpp",];

% AMPLITUDES = [0.048 0.072 0.048 0.144 0.048 0.144];
% OFFSETS = [0.968 0.968 1.042 1.042 1.260 1.260];
% LABELS = ["1mW_0.33mWpp", "1mW_0.5mWpp","2mW_0.33mWpp",  ...
%     "2mW_1mWpp", "5mW_0.33mWpp", "5mW_1mWpp"];

NUM_TESTS = length(LABELS);
START_INDEX = 1;

SIGNAL_RANGE_A = ps5000aEnuminfo.enPS5000ARange.PS5000A_200MV;
SIGNAL_RANGE_B = ps5000aEnuminfo.enPS5000ARange.PS5000A_200MV;
SAMPLING_FREQUENCY = 500000; %Hz for Analog Mics
% SAMPLING_FREQUENCY = 12500000; %Hz for Digital Mics
SAMPLE_PERIOD = 1/SAMPLING_FREQUENCY;
NUM_FREQS = 100;
START_FREQ = 20;
END_FREQ = 30000;
% NUM_FREQS = 4;
% START_FREQ = 10;
% END_FREQ = 10000;

results_folder_name = strcat('./Output/results/',DEVICE);
if ~exist(results_folder_name, 'dir')
    mkdir(results_folder_name);
end
fig_folder_name = strcat('./Output/figs/',DEVICE);
if ~exist(fig_folder_name, 'dir')
    mkdir(fig_folder_name);
end
png_folder_name = strcat('./Output/pngs/',DEVICE);
if ~exist(png_folder_name, 'dir')
    mkdir(png_folder_name);
end
potential_freqs = logspace(log10(START_FREQ), log10(END_FREQ), NUM_FREQS);

%Try to align frequencies with Sampling Frequency (some rounding error)
frequencies = SAMPLING_FREQUENCY./ceil(SAMPLING_FREQUENCY./round(potential_freqs));
try
    tek_init;
    pico_init;

    %Set chA and chB
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'A', SIGNAL_RANGE_A);
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'B', SIGNAL_RANGE_B);

     % Configure property value(s).
     Fs = 1 / (timeIntervalNanoseconds * 1e-9);

%     lpfilter = designfilt('lowpassfir', 'PassbandFrequency', 30000, ...
%                       'StopbandFrequency', 40000, 'PassbandRipple', 1, ...
%                       'StopbandAttenuation', 40, 'SampleRate', ...
%                       Fs, 'DesignMethod', 'equiripple');
   
    lpfilter = designfilt('lowpassiir', 'PassbandFrequency', 30000, ...
        'StopbandFrequency', 40000, 'PassbandRipple', 0.2, ...
        'StopbandAttenuation', 80, 'SampleRate', 10000000);          
    % Design a filter with a Q-factor of Q=35 to remove a 60 Hz tone from 
    % system running at Fs Hz.
%     Wo = 60/(Fs/2);  BW = Wo/35;
%     [b,a] = iirnotch(Wo,BW);
%     notchfilter = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
%                'DesignMethod','butter','SampleRate',Fs);
    amp_outs = zeros(NUM_TESTS, length(frequencies));
%     mag_out = zeros(NUM_TESTS, length(frequencies));
    phase_outs = zeros(NUM_TESTS, length(frequencies));
    
    set(deviceObj.Output(1), 'State', 'on');
    pause(2);
    for j = START_INDEX:START_INDEX+NUM_TESTS-1
        i = 0;
        if length(PRESSURES) < 2
            pressure_atm = PRESSURES(1) + "atm";
        else
            pressure_atm = PRESSURES(j) + "atm";
        end
        
        if WAIT_FOR_USER
            user_input = input(strcat("Begin Test ", string(j), "?\nDevice = ", DEVICE,... 
                "\nTest Label = ", LABELS(j), "\nWavelength = ", LIGHT_WAVELENGTH, "\nPressure = ", pressure_atm, ...
                "\nAmplitude = ", string(AMPLITUDES(j)), "\nOffset = ", string(OFFSETS(j)), "\n"), 's');

            if startsWith(user_input, "e") || startsWith(user_input, "c") || startsWith(user_input, "q")
                throw(MException('main:ForceTestEnd','deinitializing connections'));
            end
            while startsWith(user_input, "s")
                i = 1;
                pico_capture;
                pico_get_data;
                timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
                timeMs = timeNs / 1e6;
                plot(timeMs, chA, timeMs, chB);
                user_input = input(strcat("Begin Test ", string(j), "?\nDevice = ", DEVICE,... 
                "\nTest Label = ", LABELS(j), "\nWavelength = ", LIGHT_WAVELENGTH, "\nPressure = ", pressure_atm, ...
                "\nAmplitude = ", string(AMPLITUDES(j)), "\nOffset = ", string(OFFSETS(j)), "\n"), 's');
                if startsWith(user_input, "e") || startsWith(user_input, "c")
                    throw(MException('main:ForceTestEnd','deinitializing connections'));
                end
            end
        end
        
        close all;
        
        out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", LABELS(j), "_", pressure_atm);
        if ~exist(strcat('./Output/data/', DEVICE), 'dir')
            mkdir(strcat('./Output/data/', DEVICE));
        end
        if ~exist(strcat('./Output/data/', DEVICE, '/', out_file), 'dir')
            mkdir(strcat('./Output/data/', DEVICE, '/', out_file));
        end

        for i = 1:length(frequencies)
            set_fgen(deviceObj, frequencies(i), AMPLITUDES(j), OFFSETS(j));
%             pause; %(0.5);
            pico_capture;
            pico_get_data;

            %Testing Amplitude Accuracy
%             t = 0:1/SAMPLING_FREQUENCY:(length(chA)-1)/SAMPLING_FREQUENCY;
%             chA = chA + double(40*cos(2*pi*frequencies(i)*t'));
 
%             % I wanted to process current block while waiting for ready,
%             but the matlab driver doesn't work that way.
%             if i < length(frequencies)
%                 set_fgen(deviceObj, frequencies(i+1), AMPLITUDES(j), OFFSETS(j));
%                 pico_capture;
%             end
            if SAVE_DATA && (mod(i, ceil(NUM_FREQS/NUM_SAVED_FILES)) == 1)
                timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
                timeMs = timeNs / 1e6;
                save(strcat('./Output/data/',DEVICE,'/', out_file, '/', out_file, '_', string(frequencies(i)), 'Hz.mat'), 'chA', 'chB', 'timeMs');
            end

            if LOW_PASS_FILTER
                chA = filtfilt(lpfilter, chA);
            end
%             filt_chB = filtfilt(lpfilter, chB);
%             if FILTER_60HZ && frequencies(i) < 240
%                 filt_chA = filtfilt(notchfilter, filt_chA);
% %                 chA = filter(b,a,chA);
%             end
            
%             filt_chA = filt_chA - mean(filt_chA);
%             filt_chB = filt_chB - mean(filt_chB);
            % Calculate FFT of Channels and plot - based on <matlab:doc('fft') fft documentation>.
%             L = length(filt_chA);
%             n = 2 ^ nextpow2(L); % Next power of 2 from length of chA
            chA = chA - mean(chA);
            chB = chB - mean(chB);
            if FLIPB
                chB = -chB;
            end
            n = length(chA);
            Fs = 1 / (timeIntervalNanoseconds * 1e-9);
            f = Fs*(0:(n/2))/n;
            freq_index = find(f >= frequencies(i), 1);  
            
            % Window data
%             w = hanning(L);
%             w = flattopwin(L);
            w = blackman(n);
%             windowed_chA = filt_chA.*w; 

            Y_A = fft(chA.*w);
            % Obtain the single-sided spectrum of the signal.
            % Account for scaling due to sample number and windowing
            P2_A = abs(Y_A/n/mean(w));
            P1_A = P2_A(1:n/2+1);
            P1_A(2:end-1) = 2*P1_A(2:end-1);
    
            Y_B = fft(chB);
    %         P2_B = abs(Y_B/n);
    %         P1_B = P2_B(1:n/2+1);
    %         P1_B(2:end-2) = 2 * P1_B(2:end-2);

%             semilogx(f, P1_A);
            
            start_index = max([2 freq_index - 1]);
            end_index = min([length(Y_A) freq_index + 1]);
            [maxA_mag, maxA_ind] = max(abs(Y_A(start_index:end_index)));
            maxA_ind = maxA_ind + start_index - 1;
            [maxB_mag, maxB_ind] = max(abs(Y_B(start_index:end_index)));
            maxB_ind = maxB_ind + start_index - 1;
    %         mag_out(i) = max(P1_A); 
%             smoothed_A = movmean(filt_chA, floor(length(filt_chA)/100));
%             [~, max_indices] = findpeaks(smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4);
            maxP1_A_mag = 2*maxA_mag/n/mean(w); % Account for fft magnitude and window scaling
            maxP1_A_ind = maxA_ind;
%             if maxP1_A_ind == 1 || maxP1_A_ind == length(P1_A)
%                 max_amplitude = maxP1_A_mag;
%             else
%                 %Quadratic Peak Interpolation:
%                 a = P1_A(maxP1_A_ind-1); 
%                 b = P1_A(maxP1_A_ind); 
%                 c = P1_A(maxP1_A_ind+1);
%                 p = (a - c)/(a - 2*b + c)/2;
%                 max_amplitude = b - p*(a-c)/4;
%             end
%             subplot(2,1,1);
%             findpeaks(smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4)
%             subplot(2,1,2);
%             plot(chA)
            
%             [~, min_indices] = findpeaks(-smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4);
%             min_length = min([length(max_indices) length(min_indices)]);
%             if min_length == 0
%                 amp_out(i) = (max(smoothed_A) - min(smoothed_A))/1000;
%             else
%                 amp_out(i) = mean(smoothed_A(max_indices(1:min_length)) - smoothed_A(min_indices(1:min_length)))/1000; 
%             end

            amp_outs(j, i) = maxP1_A_mag;
            if(maxP1_A_mag < 0)
                disp(maxP1_A_mag);
            end
            
%             semilogx(frequencies, amp_out);
            phase_outs(j, i) = wrapToPi(angle(Y_A(maxA_ind)) - angle(Y_B(maxA_ind)))*180/pi;
            if maxA_ind ~= maxB_ind
                disp("****************Frequency mismatch A and B****************")
                disp(abs(angle(Y_B(maxB_ind)) - angle(Y_A(maxA_ind)))*180/pi);
            end
            if abs(freq_index - maxA_ind) > 1
                disp("****************Potential frequency mismatch****************");
                disp([freq_index, maxA_ind]);
            end
%             pause(0.5);
        end
                
        amp_out = amp_outs(j,:);
        phase_out = phase_outs(j,:);
        save(strcat(results_folder_name,'/', out_file, '.mat'), 'frequencies', 'amp_out', 'phase_out');

        %Frequency Response
        set(0, 'DefaultAxesFontSize', 16);
        figure;
        subplot(2,1,1);
        loglog(frequencies, amp_out);
        title(out_file, 'Interpreter', 'None');
        ylim([min(amp_out)/1.2 max(amp_out)*1.2]);
        xlim([0 50000]);
        ylabel('Amplitude (mV)');
        xlabel('Frequency (Hz)');

        subplot(2,1,2);
        semilogx(frequencies, phase_out);
        ylim([-180 180]);
        xlim([0 50000]);
        ylabel('Phase (degrees)');
        xlabel('Frequency (Hz)');

        fullfig(gcf);
        savefig(strcat(fig_folder_name,'/', out_file, '.fig'));
        exportgraphics(gcf,strcat(png_folder_name,'/', out_file, '.png'),'Resolution',300) 
   
    end

    set(deviceObj.Output(1), 'State', 'off');
    
    % Final Plot General
    set(0, 'DefaultAxesFontSize', 16);
    figure;
    subplot(2,1,1);
    loglog(frequencies, amp_outs);
    title(out_file, 'Interpreter', 'None');
    ylim([min(amp_outs, [], 'all')/1.2 max(amp_outs, [], 'all')*1.2]);
    legend(num2cell(DC_MW+"mW"), "Location", "southwest");
    xlim([0 50000]);
    ylabel('Amplitude (mV)');
    xlabel('Frequency (Hz)');

    subplot(2,1,2);
    semilogx(frequencies, phase_outs);
    legend(num2cell(DC_MW+"mW"), "Location", "southwest");
    ylim([-180 180]);
    xlim([0 50000]);
    ylabel('Phase (degrees)');
    xlabel('Frequency (Hz)');

    fullfig(gcf);
    out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", pressure_atm, "_2mWpp_DC");
    savefig(strcat(fig_folder_name,'/', out_file, '.fig'));
    exportgraphics(gcf,strcat(png_folder_name,'/', out_file, '.png'),'Resolution',300) 


    %Final plot (AC Response)
%     set(0, 'DefaultAxesFontSize', 16);
%     out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", pressure_atm, "_5mW_AC");
%     figure;
%     plot(AMP_MW, amp_outs);
%     legend(num2cell(frequencies+" Hz"), "Location", "northwest");
%     title(out_file, 'Interpreter', 'None');
%     ylim([min(amp_outs, [], 'all')/1.2 max(amp_outs, [], 'all')*1.2]);
%     xlim([0 max(AMP_MW)+1]);
%     ylabel('Output Amplitude (mV)');
%     xlabel('Input Amplitude (mW)');
%     
%     fullfig(gcf);
%     savefig(strcat(fig_folder_name,'/', out_file, '.fig'));
%     exportgraphics(gcf,strcat(png_folder_name,'/', out_file, '.png'),'Resolution',300) 
    
    %Final plot (DC Response)
%     set(0, 'DefaultAxesFontSize', 16);
%     out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", pressure_atm, "_2mWpp_DC");
%     figure;
%     plot(DC_MW, amp_outs);
%     legend(num2cell(frequencies+" Hz"), "Location", "northwest");
%     title(out_file, 'Interpreter', 'None');
%     ylim([min(amp_outs, [], 'all')/1.2 max(amp_outs, [], 'all')*1.2]);
%     xlim([0 max(DC_MW)+1]);
%     ylabel('Output Amplitude (mV)');
%     xlabel('DC Power (mW)');
%     
%     fullfig(gcf);
%     savefig(strcat(fig_folder_name,'/', out_file, '.fig'));
%     exportgraphics(gcf,strcat(png_folder_name,'/', out_file, '.png'),'Resolution',300) 

%Final plot (Pressure Response)
%     set(0, 'DefaultAxesFontSize', 16);
%     out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", LABELS(1), "_Pressure");
%     figure;
%     plot(PRESSURES, amp_outs);
%     legend(num2cell(frequencies+" Hz"), "Location", "northwest");
%     title(out_file, 'Interpreter', 'None');
%     ylim([min(amp_outs, [], 'all')/1.2 max(amp_outs, [], 'all')*1.2]);
%     xlim([0 1]);
%     ylabel('Output Amplitude (mV)');
%     xlabel('Pressure (atm)');
%     
%     fullfig(gcf);
%     savefig(strcat(fig_folder_name,'/', out_file, '.fig'));
%     exportgraphics(gcf,strcat(png_folder_name,'/', out_file, '.png'),'Resolution',300) 
    
    pico_deinit;
    tek_deinit;

catch ME
    if exist('interfaceObj', 'var') && ~isempty(interfaceObj) && strcmp(interfaceObj.status, 'open')
        disp("TEK DEINIT")
        tek_deinit;
    end
    if exist('ps5000aDeviceObj', 'var') && ps5000aDeviceObj.isvalid && strcmp(ps5000aDeviceObj.status, 'open') 
        disp("PICO DEINIT")
        pico_deinit;
    end
    rethrow(ME);
end

function cleanMeUp()
    
end
