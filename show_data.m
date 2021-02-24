
OUTPUT_FOLDER = './Output/data/';
DATA_FOLDER = 'SPU02_638nm_0.5mW_0.5mWpp_1atm';
DATA_FREQUENCY = '1682.4175';

convert_laser_diode_conroller = 500/10000; % mA/mV for laser diode controller


load(strcat(OUTPUT_FOLDER, DATA_FOLDER, '/', DATA_FOLDER, '_', DATA_FREQUENCY, 'Hz.mat'));

figure; hold on;
yyaxis left
plot(timeMs, chA);
title(DATA_FOLDER, 'Interpreter','none');
ylabel('Voltage (mV)');
yyaxis right
plot(timeMs, chB*convert_laser_diode_conroller);
ylabel('Current (mA)');
xlabel('Time (ms)');