
% timebaseIndex = 65;
% set(ps5000aDeviceObj, 'timebase', timebaseIndex);

num_samples = 2^nextpow2(ceil(5*1/frequencies(1)/timeIntervalNanoseconds/1e-9)); %max([2^nextpow2(ceil(20*1/frequencies(i)/timeIntervalNanoseconds/1e-9)) 2^nextpow2(3*length(lpfilter.Coefficients))]);
set(ps5000aDeviceObj, 'numPostTriggerSamples', num_samples);

[status.runBlock] = invoke(blockGroupObj, 'runBlock', 0);

% Retrieve data values:
startIndex              = 0;
segmentIndex            = 0;
downsamplingRatio       = 1;
downsamplingRatioMode   = ps5000aEnuminfo.enPS5000ARatioMode.PS5000A_RATIO_MODE_NONE;

[numSamples, overflow, chA, chB] = invoke(blockGroupObj, 'getBlockData', startIndex, segmentIndex, ...
                                            downsamplingRatio, downsamplingRatioMode);