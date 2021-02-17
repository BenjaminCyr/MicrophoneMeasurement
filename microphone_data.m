close all;

addpath("./Inc");

try
    tek_init;
    pico_init;

    % Configure property value(s).
    FREQ = 20;
    AMP = 1;
    OFFSET = 0;
    set_fgen(deviceObj, FREQ, AMP, OFFSET);

    %Set chA and chB
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'A', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)
    set_pico(ps5000aDeviceObj, ps5000aEnuminfo, status, 'B', ps5000aEnuminfo.enPS5000ARange.PS5000A_1V)

    pico_take_data;
    
    
    figure1 = figure('Name','PicoScope 5000 Series (A API) Example - Block Mode Capture with FFT', ...
        'NumberTitle','off');

    % Calculate time (nanoseconds) and convert to milliseconds
    % Use |timeIntervalNanoseconds| output from the |ps5000aGetTimebase2()|
    % function or calculate it using the main Programmer's Guide.
    % Take into account the downsampling ratio used.

    timeNs = double(timeIntervalNanoseconds) * downsamplingRatio * double(0:numSamples - 1);
    timeMs = timeNs / 1e6;

    % Channel A
    chAAxes = subplot(2,1,1); 
    plot(chAAxes, timeMs, chA, timeMs, chB);
    ylim(chAAxes, [-1500 1500]); % Adjust vertical axis for signal

    title(chAAxes, 'Block Data Acquisition');
    xlabel(chAAxes, 'Time (ms)');
    ylabel(chAAxes, 'Voltage (mV)');
    grid(chAAxes, 'on');
    legend(chAAxes, 'Channel A', 'Channel B');

    % Calculate FFT of Channel A and plot - based on <matlab:doc('fft') fft documentation>.
    L = length(chA);
    n = 2 ^ nextpow2(L); % Next power of 2 from length of chA

    Y = fft(chA, n);
    Y2 = fft(chB, n);

    % Obtain the single-sided spectrum of the signal.
    P2 = abs(Y/n);
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    
    P2_2 = abs(Y2/n);
    P1_2 = P2(1:n/2+1);
    P1_2(2:end-1) = 2 * P1_2(2:end-1);

    Fs = 1 / (timeIntervalNanoseconds * 1e-9);
    f = 0:(Fs/n):(Fs/2 - Fs/n);

    chAFFTAxes = subplot(2,1,2);
    semilogx(chAFFTAxes, f, P1(1:n/2), f, P1_2(1:n/2)); 
    xlim([0 50000]);

    title(chAFFTAxes, 'Single-Sided Amplitude Spectrum of y(t)');
    xlabel(chAFFTAxes, 'Frequency (Hz)');
    ylabel(chAFFTAxes, '|Y(f)|');
    grid(chAFFTAxes, 'on');

    [magA, IdxA] = max(abs(2*Y)/n);
    [magB, IdxB] = max(abs(2*Y2)/n);
    
    [magA angle(Y(IdxA))]
    [magB angle(Y2(IdxB))]

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