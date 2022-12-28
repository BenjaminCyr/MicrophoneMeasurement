load('AllResults.mat');
% load('MicrophoneOutput.mat');
load('VibrometerOutput.mat');

figure;

for j = 1:length(device_names)
   subplot(4, 4, 2*j-1);
   title(device_names{j});
   yyaxis left;
   loglog(out_x(j,:), out_values(j, :));
   yyaxis right;
   loglog(freqs, mag_out(j,:));
   
   subplot(4, 4, 2*j);
   title(device_names{j});
   yyaxis left;
   semilogx(out_x(j,:), out_phase(j, :));
   ylim([-180 180])
   yyaxis right;
   semilogx(freqs, phase_out(j,:));
   ylim([-180 180])
end

 savefig('AllResults.fig');