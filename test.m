clear, clc, close all

% file specifics parameters
load('Subject1_2D.mat')  % 5,6,18 = c3,c4,cz
fs = 160;
info = edfinfo('testrest.edf');
c3rest = get_edfsignal('testrest.edf', {'C3..'});
c4rest = get_edfsignal('testrest.edf', {'C4..'});
czrest = get_edfsignal('testrest.edf', {'Cz..'});
resting = [c3rest c4rest czrest];

c3move = get_edfsignal('testright.edf', {'C3..'});
c4move = get_edfsignal('testright.edf', {'C4..'});
czmove = get_edfsignal('testright.edf', {'Cz..'});
moving = [c3move c4move czmove];

% general parameters
mu = [ 8,12];
be = [18,25];
fc_low  =  8;
fc_high = 30;
f_order =  5;
window  = 1*fs;
overlap = 0.8*fs;
[b,a] = butter(f_order,[fc_low,fc_high]/(fs/2),'bandpass');

% taking a portion of the signal (the size of a window)
resting = resting(1:window,:);
moving  =  moving(1:window,:);
figure,plot(resting),title('original')

% filtering signal
resting = filtfilt(b,a,resting);
moving  = filtfilt(b,a, moving);
figure,plot(resting),title('filtered')

% csp filter (needs the 2 categories)[channels x samples]
[W, lambda, A] = csp(moving',resting');
restingX = (W'*resting')';
movingX  = (W'* moving')';

% relative power
pMu_rest = bandpower(restingX,fs,mu)/bandpower(restingX);
pBe_rest = bandpower(restingX,fs,be)/bandpower(restingX);

pMu_move = bandpower(movingX,fs,mu)/bandpower(movingX);
pBe_move = bandpower(movingX,fs,be)/bandpower(movingX);

function [y] = filt_signal(b,a,x)
    y = filtfilt(b,a,x);
end

function [signal] = get_edfsignal(edf_path, name_col)
    original_signal = edfread(edf_path,'SelectedSignals', name_col);
    original_signal = table2array(original_signal);
    signal = vertcat(original_signal{:});
end

