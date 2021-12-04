clc, clear

% load model
load('Model_0 .mat')
load('test_data.mat')

%
fs = 160;
window  = 1.0*fs;

% classify
test_classify = data(end-window+1:end, 1:3)

[~,score_svm] = predict( cl_svm, test_classify  );