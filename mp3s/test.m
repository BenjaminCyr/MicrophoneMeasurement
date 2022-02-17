clear all;
close all;

[y, Fs] = audioread("sample-0.mp3");
t = 0:1/Fs:(length(y)-1)/Fs;

% plot(t, y);
% sound(y, Fs);
y = y(2:2000);
n = length(y);
f = Fs*(0:(n/2))/n;

w = blackman(n);

Yf = fft(y.*w);

P2_A = abs(Yf/n/mean(w));
P1_A = P2_A(1:n/2+1);
P1_A(2:end-1) = 2*P1_A(2:end-1);

figure;
subplot(2, 1, 1);
loglog(P1_A);

subplot(2, 1, 2);

Y = unwrap(angle(Yf));
X = [ones(length(f), 1) f'];
b = X\Y;


plot([unwrap(angle(Yf)); X*b])