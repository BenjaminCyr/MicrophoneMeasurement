pico_init;
tek_init;



% Configure property value(s).
set(deviceObj.Frequency(1), 'Mode', 'Continuous')
set(deviceObj.Frequency(1), 'Frequency', 1000)
set(deviceObj.Voltage(1), 'Amplitude', 0.1)
set(deviceObj.Output(1), 'State', 'on');
pause(0.5);

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
plot(chAAxes, timeMs, chA);
ylim(chAAxes, [-150 150]); % Adjust vertical axis for signal

title(chAAxes, 'Block Data Acquisition');
xlabel(chAAxes, 'Time (ms)');
ylabel(chAAxes, 'Voltage (mV)');
grid(chAAxes, 'on');
legend(chAAxes, 'Channel A');

% Calculate FFT of Channel A and plot - based on <matlab:doc('fft') fft documentation>.
L = length(chA);
n = 2 ^ nextpow2(L); % Next power of 2 from length of chA

Y = fft(chA, n);

% Obtain the single-sided spectrum of the signal.
P2 = abs(Y/n);
P1 = P2(1:n/2+1);
P1(2:end-1) = 2 * P1(2:end-1);

Fs = 1 / (timeIntervalNanoseconds * 1e-9);
f = 0:(Fs/n):(Fs/2 - Fs/n);

chAFFTAxes = subplot(2,1,2);
semilogx(chAFFTAxes, f, P1(1:n/2)); 
xlim([0 30000]);

title(chAFFTAxes, 'Single-Sided Amplitude Spectrum of y(t)');
xlabel(chAFFTAxes, 'Frequency (Hz)');
ylabel(chAFFTAxes, '|Y(f)|');
grid(chAFFTAxes, 'on');



pico_deinit;
tek_deinit;