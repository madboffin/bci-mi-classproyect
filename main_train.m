clear, clc, close all

% variables to change with each participant
record_number = 0;
fs = 160;

% file specifics parameters
load('test_data.mat')    % data(c3,c4,cz,class)
load("filter_coef.mat")  % b,a
model_name  = ['Model_' num2str(record_number)];

% general parameters
mu = [ 9,14];
be = [15,25];
window  = 1.0*fs;
overlap = 0.9*fs;

%% preprocessing - processing
data_sliced = [];
features = [];
k_start = 1;

while ( (k_start+window) <  length(data)) %length(data)
    
    % slicing by window
    data_window = data(k_start:k_start + window,:);
    
    % checking if the condition is the same in the whole slice
    % if any value of the array is different from the initial one, restart
    if any(data_window(:,4) ~= data_window(1,4))
        k_start = k_start + window - overlap;
        continue
    end
    
    % filtering signals
    data_window(:,1:3) = filtfilt(b,a,data_window(:,1:3));

    % calculating power and relative power of beta and mu
    bands = [];
    for k=1:3
        pSM = bandpower(data_window(:,k));
        pBe = bandpower(data_window(:,k),fs,be);
        pMu = bandpower(data_window(:,k),fs,mu);
        pBe_r = pBe/bandpower(data_window(:,k));
        pMu_r = pMu/bandpower(data_window(:,k));

        % order of features array
        bands = [bands  pSM pBe pMu pBe_r pMu_r];
    end
    
    bands = [bands data_window(1,4)];

    % concatenating data 
    data_sliced = [data_sliced; data_window];
    features = [features ; bands];

    % updating slice of window
    k_start = k_start + window - overlap;
end

%% separation of classes
f_rest = features(features(:,end)==1, :);
f_move = features(features(:,end)==2, :) ;

%% ERD - ERS
% ERD/ERS=(P_event)-(P_rest_avg)/(P_rest_avg)*100
p_rest_ave = mean(f_rest, 1);
p_move_ave = mean(f_move, 1);
SM_erd_ers = (f_move - p_rest_ave) / p_rest_ave * 100

%% csp filter
data_sli_rest = data_sliced(data_sliced(:,end)==1, 1:3)';
data_sli_move = data_sliced(data_sliced(:,end)==2, 1:3)';

% csp filter needs the 2 categories. Shape: [channels x samples]
[W, lambda, A] = csp(data_sli_move, data_sli_rest);
v = (W'*data_sli_rest)';
restingX = (W'* data_sli_move)';
movingX  = (W'* data_sli_move)';

% los lambdas se pueden usar como caracteristicas
%% model training

tt_data = features(:,1:end-1);
tt_y    = features(:,end);
cv = cvpartition(tt_data(:,end), 'KFold', 10);

% SVM Classifier: muy lento o no converge
cl_svm = fitcsvm(tt_data, tt_y);

% LDA
cl_lda = fitcdiscr(tt_data, tt_y);



% ANN
% for k = 1:10
% 
%     % splitting data by folds
%     xtrain = tt_data(cv.training(k),1:end);
%     xtest  = tt_data(cv.test(k),1:end-1);
%     ytrain = tt_y(cv.training(k),end);
%     ytest  = tt_y(cv.test(k),end);
%     
%     % training ANN
%     cl_net = feedforwardnet(10);
%     cl_net = train(cl_net, xtrain', ytrain');
%     pred = sign(cl_net(xtest'));
% 
% end

save(strjoin([model_name ".mat"]),"cl_lda")

%% classification

[~,score_svm] = predict( cl_svm, f_move(1:3,1:end-1) );
[~,score_lda] = predict( cl_lda, f_move(1:3,1:end-1) );  %50 percent slower than svm
%% useful functions
function [signal] = apply_LF(top, left, right, bottom, chann)
    x1 = get_edfdata('data_rest.edf', {top});
    x2 = get_edfdata('data_rest.edf', {left});
    x3 = get_edfdata('data_rest.edf', {right});
    x4 = get_edfdata('data_rest.edf', {bottom});
    LF_avg = mean( [x1 x2 x3 x4], 2 );
    signal = get_edfdata('data_rest.edf', {chann}) - LF_avg;
end