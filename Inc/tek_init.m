% Create a VISA-USB object.
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB::0x0699::0x0343::C024242::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('tek', 'USB::0x0699::0x0343::C024242::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object. 
deviceObj = icdevice('tek_afg3000.mdd', interfaceObj);

% Connect device object to hardware.
connect(deviceObj);
set(deviceObj.Function(1), 'Shape', 'sinusoid')
set(deviceObj.Frequency(1), 'Mode', 'Continuous')
set(deviceObj.Output(1), 'Impedance', 'Infinity');
set_fgen(deviceObj, frequencies(1), AMPLITUDES(START_INDEX), OFFSETS(START_INDEX));
%set(deviceObj.Output(1), 'State', 'on');
