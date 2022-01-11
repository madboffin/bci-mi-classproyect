clc, clear, close all

fs = 500;

fc_low  =  8;
fc_high = 30;
f_order =  8;
[b,a] = butter(f_order,[fc_low,fc_high]/(fs/2),'bandpass');
save("filter_coef.mat", "a","b")