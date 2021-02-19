close all;
addpath("./Inc");

AMP = 0.124;
OFFSET = 1.016;
frequencies = logspace(log10(20),log10(30000), 200);
% frequencies = [100, 1000, 10000];

out_file = "ADMP01_450nm_2mW_1mWpp_1atm";
out_title = "ADMP01 450nm 2mW 1mWpp 1atm";

try
    tek_init;
    pico_init;

    %Set chA and chB
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'A', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'B', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)

    
     % Configure property value(s).
    amp_out = zeros(1, length(frequencies));
    mag_out = zeros(1, length(frequencies));
    phase_out = zeros(1, length(frequencies));
    for i = 1:length(frequencies)
        set_fgen(deviceObj, frequencies(i), AMP, OFFSET);
        pico_take_data;
        
        % Calculate FFT of Channels and plot - based on <matlab:doc('fft') fft documentation>.
        L = length(chA);
        n = 2 ^ nextpow2(L); % Next power of 2 from length of chA
        Fs = 1 / (timeIntervalNanoseconds * 1e-9);
        f = 0:(Fs/n):(Fs/2 - Fs/n);
        
        freq_index = find(f >= frequencies(i), 1);  

        Y_A = fft(chA, n);
        % Obtain the single-sided spectrum of the signal.
%         P2_A = abs(Y_A/n);
%         P1_A = P2_A(1:n/2+1);
%         P1_A(2:end-2) = 2 * P1_A(2:end-2);
% 
        Y_B = fft(chB, n);
%         P2_B = abs(Y_B/n);
%         P1_B = P2_B(1:n/2+1);
%         P1_B(2:end-2) = 2 * P1_B(2:end-2);
        
        %semilogx(f, P1_A(1:n/2), f, P1_B(1:n/2));
        
        [maxA_mag, maxA_ind] = max(abs(Y_A));
        [maxB_mag, maxB_ind] = max(abs(Y_B));
%         mag_out(i) = max(P1_A); 
        smoothed_A = movmean(chA, floor(length(chA)/100));
        [~, max_indices] = findpeaks(smoothed_A, 'MinPeakDistance', floor(length(chA)/10), 'MinPeakProminence', max(chA)/2);
        [~, min_indices] = findpeaks(-smoothed_A, 'MinPeakDistance', floor(length(chA)/10), 'MinPeakProminence', max(chA)/2);
        min_length = min([length(max_indices) length(min_indices)]);
        
        amp_out(i) = mean(smoothed_A(max_indices(1:min_length)) - smoothed_A(min_indices(1:min_length)))/1000;
        
        phase_out(i) = wrapToPi(angle(Y_B(maxA_ind)) - angle(Y_A(maxA_ind)))*180/pi;
        if maxA_ind ~= maxB_ind
            disp("****************Frequency mismatch A and B****************")
            disp(abs(angle(Y_B(maxB_ind)) - angle(Y_A(maxA_ind)))*180/pi);
        end
        if abs(freq_index - maxA_ind) > 1
            disp("****************Potential frequency mismatch****************");
            disp([freq_index, maxA_ind]);
        end
    end
    
    set(0, 'DefaultAxesFontSize', 16);
    figure;
    subplot(2,1,1);
    
    loglog(frequencies, amp_out);
    title(out_title);
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