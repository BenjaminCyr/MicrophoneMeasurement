set(deviceObj.Output(1), 'State', 'off');

% Disconnect device object from hardware.
disconnect(deviceObj);

% Delete objects.
delete([deviceObj interfaceObj]);
