function [] = set_fgen(deviceObj, frequency, amplitude, offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Configure property value(s).
%set(deviceObj.Output(1), 'State', 'off');
set(deviceObj.Frequency(1), 'Frequency', frequency)
set(deviceObj.Voltage(1), 'Amplitude', amplitude)
set(deviceObj.Voltage(1), 'Offset', offset )
pause(0.01);
end

