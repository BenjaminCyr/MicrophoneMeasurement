Fs = 320000;
Ts = 1/Fs;
NUM_FREQS = 100;
AMPLITUDE = 10;
NOISE_AMPLITUDE = 10;
NOISE_FREQUENCY = 60;
potential_freqs = logspace(log10(20), log10(30000), NUM_FREQS);

frequencies = Fs./ceil(Fs./round(potential_freqs));
% frequencies = potential_freqs;

% min_num_samples = 4;
min_num_samples = ceil(6*1/frequencies(1)/Ts);
min_num_samples = min_num_samples + rem(min_num_samples, 2);

% multiple = num_samples*Ts*hunted_freq
amp_out = zeros(1, NUM_FREQS);
errors = zeros(1, NUM_FREQS);
for i = 1:NUM_FREQS
    hunted_freq = frequencies(i);
    
    potential_num_samples = min_num_samples:2:(min_num_samples + 1/hunted_freq/Ts);
    integer_part = floor(potential_num_samples*Ts*hunted_freq);
    fractional_part = potential_num_samples*Ts*hunted_freq - integer_part;
    [val, num_samples_index] = min(fractional_part);
    num_samples = potential_num_samples(num_samples_index);
    
%     num_samples = min_num_samples;
    
    t = 0:Ts:Ts*(num_samples-1);
    L = length(t);
    x = AMPLITUDE*sin(2*pi*hunted_freq*t + 1);
    n = NOISE_AMPLITUDE*sin(2*pi*NOISE_FREQUENCY*t + pi/2);
    
    x = x + n;

%     w = rectwin(L);
    w = blackman(L);
%     w = blackmanharris(L);
%     w = flattopwin(L);
%     n = 2^nextpow2(length(x));
    Y = fft(x.*w');
    n = num_samples;
%     Y = fft(x,n);
    % n = length(Y);
    P2 = abs(Y/n/mean(w));
    P1 = P2(1:(n/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(n/2))/n;

    expected_f = find(f >= hunted_freq, 1);  

%     a = P1(expected_f-1); 
%     b = P1(expected_f); 
%     c = P1(expected_f+1);
%     p = (a - c)/(a - 2*b + c)/2;
    amplitude = max(P1(expected_f-1:expected_f+1));
    max_amplitude = a - p*(a-c)/4;
    estimated_location = f(expected_f) + p*Fs/n;
%     disp([hunted_freq estimated_location])
    amp_out(i) = amplitude;
    errors(i) = abs(AMPLITUDE - amplitude)/AMPLITUDE;
    

%     subplot(2,1,1);
%     plot(t, x);
%     subplot(2,1,2);
%     semilogx(f, P1);
end

figure;
% subplot(2,1,1);
% plot(t, x);
% subplot(2,1,2);
semilogx(frequencies, amp_out);

closest = find(abs(NOISE_FREQUENCY - frequencies) == min(abs(NOISE_FREQUENCY - frequencies)));
errors(closest)=[];
average_error = mean(errors)*100
worst_case_error = max(errors)*100
