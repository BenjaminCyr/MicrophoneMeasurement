
timebaseIndex = 65;
set(ps5000aDeviceObj, 'timebase', timebaseIndex);

num_samples = ceil(4*1/FREQ/timeIntervalNanoseconds/1e-9);
set(ps5000aDeviceObj, 'numPostTriggerSamples', num_samples);

[status.runBlock] = invoke(blockGroupObj, 'runBlock', 0);

% Retrieve data values:
startIndex              = 0;
segmentIndex            = 0;
downsamplingRatio       = 1;
downsamplingRatioMode   = ps5000aEnuminfo.enPS5000ARatioMode.PS5000A_RATIO_MODE_NONE;

[numSamples, overflow, chA, chB] = invoke(blockGroupObj, 'getBlockData', startIndex, segmentIndex, ...
                                            downsamplingRatio, downsamplingRatioMode);