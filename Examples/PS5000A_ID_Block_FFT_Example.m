%% PicoScope 5000 Series (A API) Instrument Driver Oscilloscope Block Data Capture with FFT Example
% This is an example of an instrument control session using a device 
% object. The instrument control session comprises all the steps you 
% are likely to take when communicating with your instrument. 
%
% These steps are:
%    
% # Create a device object   
% # Connect to the instrument 
% # Configure properties 
% # Invoke functions 
% # Disconnect from the instrument 
%  
% To run the instrument control session, type the name of the file,
% PS5000A_ID_Block_FFT_Example, at the MATLAB command prompt.
% 
% The file, PS5000A_ID_BLOCK_FFT_EXAMPLE.M must be on your MATLAB PATH. For
% additional information on setting your MATLAB PATH, type 'help addpath'
% at the MATLAB command prompt.
%
% *Example:*
%     PS5000A_ID_Block_FFT_Example;
%
% *Description:*
%     Demonstrates how to call functions in order to capture a block of
%     data from a PicoScope 5000 Series Oscilloscope and calculates FFT
%     on Channel A.
%
% *See also:* <matlab:doc('fft') |fft|> | <matlab:doc('icdevice') |icdevice|> | <matlab:doc('instrument/invoke') |invoke|>
%
% *Copyright:* © 2013-2018 Pico Technology Ltd. See LICENSE file for terms.

%% Suggested input test signals
% This example was published using the following test signals
%
% * Channel A: 4 Vpp, 10 kHz square wave

%% Clear command window and close any figures

clc;
close all;

%% Load configuration information

PS5000aConfig;
pico_init;
pico_take_data;

%% Process data
% Plot data values, calculate and plot FFT.

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
plot(chAFFTAxes, f, P1(1:n/2)); 
xlim([0 30000]);

title(chAFFTAxes, 'Single-Sided Amplitude Spectrum of y(t)');
xlabel(chAFFTAxes, 'Frequency (Hz)');
ylabel(chAFFTAxes, '|Y(f)|');
grid(chAFFTAxes, 'on');

pico_deinit;