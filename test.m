clear, clc
load('Subject1_2D.mat')
fs = 500;
fc_low = 8;
fc_high=30;
f_order= 5;
% 5,6,18 = c3,c4,cz
tic
[b,a]=butter(f_order,[fc_low,fc_high]/(fs/2),'bandpass');
toc
figure, freqz(b,a,fs,fs)


% [b,a]=butter(f_order,[fc_high]/(fs/2),'low');
% figure, freqz(b,a,fs,fs)
% 
% [b,a]=butter(f_order,[fc_low]/(fs/2),'high');
% figure, freqz(b,a,fs,fs)

tic
[b,a]=cheby2(f_order, 60,[fc_low,fc_high]/(fs/2),'bandpass');
toc

figure, freqz(b,a,fs,fs)

filtsig=filtfilt(b,a,inputsig);  %filtered signal

% function filt_signal[y]=(x)
% end