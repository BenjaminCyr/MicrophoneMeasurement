% timebaseIndex = 65;
% set(ps5000aDeviceObj, 'timebase', timebaseIndex);

%Calculate the nearest multiple  of the target frequency to get highest
%amplitude accuracy.
minimum_num_samples = ceil(2*1/frequencies(1)/timeIntervalNanoseconds/1e-9);
minimum_num_samples = minimum_num_samples + rem(minimum_num_samples, 2);

potential_num_samples = minimum_num_samples:2:(minimum_num_samples + SAMPLING_FREQUENCY/frequencies(i));
potential_multiples = potential_num_samples*frequencies(i)/SAMPLING_FREQUENCY;
integer_parts = floor(potential_multiples);
fractional_parts = potential_multiples - integer_parts;
[~, num_samples_index] = min(fractional_parts);

num_samples = potential_num_samples(num_samples_index); 
%max([2^nextpow2(ceil(20*1/frequencies(i)/timeIntervalNanoseconds/1e-9)) 2^nextpow2(3*length(lpfilter.Coefficients))]);
set(ps5000aDeviceObj, 'numPostTriggerSamples', num_samples);

[status.runBlock] = invoke(blockGroupObj, 'runBlock', 0);