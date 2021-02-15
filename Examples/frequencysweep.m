%FREQUENCYSWEEPTEK M-Code for communicating with an instrument. 
%  
%   This is the machine generated representation of an instrument control 
%   session using a device object. The instrument control session comprises  
%   all the steps you are likely to take when communicating with your  
%   instrument. These steps are:
%       
%       1. Create a device object   
%       2. Connect to the instrument 
%       3. Configure properties 
%       4. Invoke functions 
%       5. Disconnect from the instrument 
%  
%   To run the instrument control session, type the name of the M-file,
%   frequencysweepTek, at the MATLAB command prompt.
% 
%   The M-file, FREQUENCYSWEEPTEK.M must be on your MATLAB PATH. For additional information
%   on setting your MATLAB PATH, type 'help addpath' at the MATLAB command
%   prompt.
%
%   Example:
%       frequencysweepTek;
%
%   See also ICDEVICE.
%

%   Creation time: 09-Mar-2009 15:28:00 


tek_init;
% Configure property value(s).
set(deviceObj.Frequency(1), 'Mode', 'Continuous')
set(deviceObj.Frequency(1), 'Frequency', 200)
set(deviceObj.Voltage(1), 'Amplitude', 0.1)
set(deviceObj.Output(1), 'State', 'on');
pause(5);
tek_deinit;