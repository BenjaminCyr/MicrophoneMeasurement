function [] = set_fgen(frequency, amplitude, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Configure property value(s).
set(deviceObj.Output(1), 'State', 'off');
pause(0.1);
set(deviceObj.Frequency(1), 'Mode', 'Continuous')
set(deviceObj.Frequency(1), 'Frequency', frequency)
set(deviceObj.Voltage(1), 'Amplitude', amplitude)
set(deviceObj.Voltage(1), 'Offset', offset )
set(deviceObj.Output(1), 'State', 'on');
pause(0.2);
end

