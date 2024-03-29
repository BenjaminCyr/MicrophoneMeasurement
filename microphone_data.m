close all;
addpath("./Inc");

% create our clean up object
% cleanupObj = onCleanup(@cleanMeUp);

SAVE_DATA = true;
FILTER_60HZ = false;
NUM_SAVED_FILES = 5;

DEVICE = "VM01_DPKG_MEMFRONT";
LIGHT_WAVELENGTH = "450nm";
NUM_TESTS = 1;
START_INDEX = 8;
% AMPLITUDES = [0.052 0.078 0.052 0.078 0.052 0.156 0.052 0.156];
% OFFSETS = [2.604 2.604 2.652 2.652 2.728 2.728 2.962 2.962];
% LABELS = ["0.5mW_0.33mWpp", "0.5mW_0.5mWpp", "1mW_0.33mWpp", "1mW_0.5mWpp",...
%     "2mW_0.33mWpp",  "2mW_1mWpp", "5mW_0.33mWpp", "5mW_1mWpp"];
PRESSURE_ATM = "1atm";
% AMPLITUDES = [0.040 0.040 0.040 0.040];
% OFFSETS = [2.624 2.672 2.748 2.974];
% LABELS = ["0.5mW_0.25mWpp", "1mW_0.25mWpp",...
%     "2mW_0.25mWpp", "5mW_0.25mWpp"];


NUM_FREQS = 100;
frequencies = logspace(log10(20),log10(30000), NUM_FREQS);
% frequencies = [100, 1000, 10000];
try
    tek_init;
    pico_init;

    %Set chA and chB
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'A', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'B', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)

     % Configure property value(s).
     Fs = 1 / (timeIntervalNanoseconds * 1e-9);
%     lpfilter = designfilt('lowpassfir', ...
%    'PassbandFrequency',30000,'StopbandFrequency',40000, ...
%    'StopbandAttenuation',20, ...
%    'DesignMethod','butter', 'SampleRate', Fs);
    lpfilter = designfilt('lowpassfir', 'PassbandFrequency', 30000, ...
                      'StopbandFrequency', 40000, 'PassbandRipple', 1, ...
                      'StopbandAttenuation', 20, 'SampleRate', ...
                      Fs, 'DesignMethod', 'equiripple');
    % Design a filter with a Q-factor of Q=35 to remove a 60 Hz tone from 
    % system running at Fs Hz.
%     Wo = 60/(Fs/2);  BW = Wo/35;
%     [b,a] = iirnotch(Wo,BW);
    notchfilter = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
    amp_out = zeros(1, length(frequencies));
    mag_out = zeros(1, length(frequencies));
    phase_out = zeros(1, length(frequencies));
    for j = START_INDEX:START_INDEX+NUM_TESTS-1
        
        user_input = input(strcat("Begin Test ", string(j), "?\nDevice = ", DEVICE,... 
            "\nTest Label = ", LABELS(j), "\nWavelength = ", LIGHT_WAVELENGTH, "\nPressure = ", PRESSURE_ATM, ...
            "\nAmplitude = ", string(AMPLITUDES(j)), "\nOffset = ", string(OFFSETS(j)), "\n"), 's');
        
        if startsWith(user_input, "e") || startsWith(user_input, "c")
            throw(MException('main:ForceTestEnd','deinitializing connections'));
        end
        while startsWith(user_input, "s")
            i = 1;
            pico_take_data;
            timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
            timeMs = timeNs / 1e6;
            plot(timeMs, filt_chA, timeMs, filt_chB);
            user_input = input(strcat("Begin Test ", string(j), "?\nDevice = ", DEVICE,... 
            "\nTest Label = ", LABELS(j), "\nWavelength = ", LIGHT_WAVELENGTH, "\nPressure = ", PRESSURE_ATM, ...
            "\nAmplitude = ", string(AMPLITUDES(j)), "\nOffset = ", string(OFFSETS(j)), "\n"), 's');
            if startsWith(user_input, "e") || startsWith(user_input, "c")
                throw(MException('main:ForceTestEnd','deinitializing connections'));
            end
        end
        
        close all;
        
        out_file = strcat(DEVICE, "_", LIGHT_WAVELENGTH, "_", LABELS(j), "_", PRESSURE_ATM);
        mkdir(strcat('./Output/data/', out_file));

        set(deviceObj.Output(1), 'State', 'on');
        pause(0.5);
%         figure;
        for i = 1:length(frequencies)
            set_fgen(deviceObj, frequencies(i), AMPLITUDES(j), OFFSETS(j));
            pico_take_data;
            if SAVE_DATA && (mod(i, ceil(NUM_FREQS/NUM_SAVED_FILES)) == 1)
                timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
                timeMs = timeNs / 1e6;
                save(strcat('./Output/data/', out_file, '/', out_file, '_', string(frequencies(i)), 'Hz.mat'), 'chA', 'chB', 'timeMs');
            end

            filt_chA = filtfilt(lpfilter, chA);
            filt_chB = filtfilt(lpfilter, chB);
            if FILTER_60HZ && frequencies(i) < 240
                filt_chA = filtfilt(notchfilter, filt_chA);
%                 chA = filter(b,a,chA);
            end
            
            filt_chA = filt_chA - mean(filt_chA);
            filt_chB = filt_chB - mean(filt_chB);
            % Calculate FFT of Channels and plot - based on <matlab:doc('fft') fft documentation>.
            L = length(filt_chA);
            n = 2 ^ nextpow2(L); % Next power of 2 from length of chA
            Fs = 1 / (timeIntervalNanoseconds * 1e-9);
            f = 0:(Fs/n):(Fs/2 - Fs/n);

            freq_index = find(f >= frequencies(i), 1);  

            Y_A = fft(filt_chA, n);
            % Obtain the single-sided spectrum of the signal.
    %         P2_A = abs(Y_A/n);
    %         P1_A = P2_A(1:n/2+1);
    %         P1_A(2:end-2) = 2 * P1_A(2:end-2);
    % 
            Y_B = fft(filt_chB, n);
    %         P2_B = abs(Y_B/n);
    %         P1_B = P2_B(1:n/2+1);
    %         P1_B(2:end-2) = 2 * P1_B(2:end-2);

            %semilogx(f, P1_A(1:n/2), f, P1_B(1:n/2));
            start_index = max([2 freq_index - 3]);
            end_index = min([length(Y_A) freq_index + 3]);
            [maxA_mag, maxA_ind] = max(abs(Y_A(start_index:end_index)));
            maxA_ind = maxA_ind + start_index - 1;
            [maxB_mag, maxB_ind] = max(abs(Y_B(start_index:end_index)));
            maxB_ind = maxB_ind + start_index - 1;
    %         mag_out(i) = max(P1_A); 
            smoothed_A = movmean(filt_chA, floor(length(filt_chA)/100));
            [~, max_indices] = findpeaks(smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4);
            
%             subplot(2,1,1);
%             findpeaks(smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4)
%             subplot(2,1,2);
%             plot(chA)
            
            [~, min_indices] = findpeaks(-smoothed_A, 'MinPeakDistance', floor(length(filt_chA)/10), 'MinPeakProminence', max(filt_chA)/4);
            min_length = min([length(max_indices) length(min_indices)]);
            if min_length == 0
                amp_out(i) = (max(smoothed_A) - min(smoothed_A))/1000;
            else
                amp_out(i) = mean(smoothed_A(max_indices(1:min_length)) - smoothed_A(min_indices(1:min_length)))/1000; 
            end

            phase_out(i) = wrapToPi(angle(Y_A(maxA_ind)) - angle(Y_B(maxA_ind)))*180/pi;
            if maxA_ind ~= maxB_ind
                disp("****************Frequency mismatch A and B****************")
                disp(abs(angle(Y_B(maxB_ind)) - angle(Y_A(maxA_ind)))*180/pi);
            end
            if abs(freq_index - maxA_ind) > 1
                disp("****************Potential frequency mismatch****************");
                disp([freq_index, maxA_ind]);
            end
        end
        set(deviceObj.Output(1), 'State', 'off');
        
        save(strcat('./Output/results/', out_file, '.mat'), 'frequencies', 'amp_out', 'phase_out');
        set(0, 'DefaultAxesFontSize', 16);
        figure;
        subplot(2,1,1);
        loglog(frequencies, amp_out);
        title(out_file, 'Interpreter', 'None');
    %     title('Frequency Response');
        ylim([0 max(amp_out)*1.2]);
        ylabel('Peak-to-Peak Voltage (V)');
        xlabel('Frequency (Hz)');

        subplot(2,1,2);
        semilogx(frequencies, phase_out);
    %     title('Phase Response');
        ylim([-180 180]);
        ylabel('Phase (degrees)');
        xlabel('Frequency (Hz)');

    %     subplot(3,1,3);
    %     loglog(frequencies, mag_out);

        fullfig(gcf);
        savefig(strcat('./Output/figs/', out_file, '.fig'));
        exportgraphics(gcf,strcat('./Output/pngs/', out_file, '.png'),'Resolution',300) 
   
    end
    
%     figure1 = figure('Name','PicoScope 5000 Series (A API) Example - Block Mode Capture with FFT', ...
%         'NumberTitle','off');
% 
%     % Calculate time (nanoseconds) and convert to milliseconds
%     % Use |timeIntervalNanoseconds| output from the |ps5000aGetTimebase2()|
%     % function or calculate it using the main Programmer's Guide.
%     % Take into account the downsampling ratio used.
% 
%     timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
%     timeMs = timeNs / 1e6;
% 
%     % Channel A
%     chAAxes = subplot(2,1,1); 
%     plot(chAAxes, timeMs, chA, timeMs, chB);
%     ylim(chAAxes, [-1500 1500]); % Adjust vertical axis for signal
% 
%     title(chAAxes, 'Block Data Acquisition');
%     xlabel(chAAxes, 'Time (ms)');
%     ylabel(chAAxes, 'Voltage (mV)');
%     grid(chAAxes, 'on');
%     legend(chAAxes, 'Channel A', 'Channel B');
% 
%     
% 
%     chAFFTAxes = subplot(2,1,2);
%     semilogx(chAFFTAxes, f, P1_A(1:n/2), f, P1_B(1:n/2)); 
%     xlim([0 50000]);
% 
%     title(chAFFTAxes, 'Single-Sided Amplitude Spectrum of y(t)');
%     xlabel(chAFFTAxes, 'Frequency (Hz)');
%     ylabel(chAFFTAxes, '|Y(f)|');
%     grid(chAFFTAxes, 'on');
% 
%     [magA, IdxA] = max(abs(2*Y_A)/n);
%     [magB, IdxB] = max(abs(2*Y_B)/n);
%     
%     [magA angle(Y_A(IdxA))]
%     [magB angle(Y_B(IdxB))]

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
