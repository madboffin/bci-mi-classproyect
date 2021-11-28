clear, clc, close all

% file specifics parameters
fs = 160;
info = edfinfo('data_rest.edf');

% reading edf data for resting condition
c3 = get_edfdata('data_rest.edf', {'C3..'});
c4 = get_edfdata('data_rest.edf', {'C4..'});
cz = get_edfdata('data_rest.edf', {'Cz..'});
rest = [c3 c4 cz zeros(length(c3),1)];
rest = rest(1:9000,:);

% reading edf data for movement condition
c3 = get_edfdata('data_right.edf', {'C3..'});
c4 = get_edfdata('data_right.edf', {'C4..'});
cz = get_edfdata('data_right.edf', {'Cz..'});
move = [c3 c4 cz ones(length(c3),1)];
move = move(1:9000,:);

data = [rest; move];
save("test_data.mat", "data")

%% useful functions
function [signal] = get_edfdata(edf_path, name_col)
    original_signal = edfread(edf_path,'SelectedSignals', name_col);
    original_signal = table2array(original_signal);
    signal = vertcat(original_signal{:});
end