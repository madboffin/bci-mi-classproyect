clear, clc, close all

% variables to change
record_number = 0;
fs = 160;

% file specifics parameters
load('test_data.mat')    % data(c3,c4,cz,class)
load("filter_coef.mat")  % b,a
create_test_array(fs)

model_name  = ['model_' num2str(record_number)];

% general parameters
mu = [ 9,14];
be = [15,25];
window  = 1.0*fs;
overlap = 0.9*fs;

%% preprocessing - processing
data_sliced = [];
v_features = [];
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
    chann_features = [];
    for k=1:3
        features = get_features(data_window(:,k),fs);
        chann_features = [chann_features features];
    end
    
    chann_features = [chann_features data_window(1,4)];

    % concatenating data 
    data_sliced = [data_sliced; data_window];
    v_features = [v_features ; chann_features];

    % updating slice of window
    k_start = k_start + window - overlap;
end

%% separation of classes
f_rest = v_features(v_features(:,end)==0, :);
f_move = v_features(v_features(:,end)==1, :) ;

%% ERD - ERS
% ERD/ERS=(P_event)-(P_rest_avg)/(P_rest_avg)*100
p_rest_avg = mean(f_rest, 1);
SM_erd_ers = (f_move - p_rest_avg) / p_rest_avg * 100;

%% csp filter
% data_sli_rest = data_sliced(data_sliced(:,end)==1, 1:3)';
% data_sli_move = data_sliced(data_sliced(:,end)==2, 1:3)';
% 
% % csp filter needs the 2 categories. Shape: [channels x samples]
% [W, lambda, A] = csp(data_sli_move, data_sli_rest);
% v = (W'*data_sli_rest)';
% restingX = (W'* data_sli_move)';
% movingX  = (W'* data_sli_move)';

% los lambdas se pueden usar como caracteristicas
%% model training
tt_data = v_features(:,1:end-1);
tt_y    = v_features(:,end);

% cross validation
% for k = 1:10
%     pred = sign(cl_net(xtest'));
% end
cv = cvpartition(length(tt_y), 'HoldOut', 0.6);
xtrain = tt_data(training(cv),:);
xtest  = tt_data(test(cv),:);
ytrain = tt_y(training(cv));
ytest  = tt_y(test(cv));

% SVM Classifier
cl_svm = fitcsvm(xtrain, ytrain);

% LDA
cl_lda = fitcdiscr(xtrain, ytrain);

% ANN
cl_net = feedforwardnet(10, 'traingdm');
cl_net = train(cl_net, xtrain', ytrain');

save(strjoin([model_name ".mat"]), "cl_lda", "cl_svm")

%%
ypred = predict( cl_svm, xtest );
cp_svm = classperf(ytest, ypred);

ypred = predict( cl_lda, xtest );
cp_lda = classperf(ytest, ypred);

ypred = cl_net(xtest');
perform( cl_net, ypred, ytest' );

figure, plotconfusion(ytest', ypred)

%% useful functions

function [signal] = apply_LF(top, left, right, bottom, chann)
    x1 = get_edfdata('data_rest.edf', {top});
    x2 = get_edfdata('data_rest.edf', {left});
    x3 = get_edfdata('data_rest.edf', {right});
    x4 = get_edfdata('data_rest.edf', {bottom});
    LF_avg = mean( [x1 x2 x3 x4], 2 );
    signal = get_edfdata('data_rest.edf', {chann}) - LF_avg;
end
