clear, clc, close all

% file specifics parameters
fs = 160;
info = edfinfo('data_rest.edf');

% reading edf data for resting condition

% for laplacian filter (taking mean of surrounding electrodes)
fc3 = get_edfdata('data_rest.edf', {'Fc3.'});
c5  = get_edfdata('data_rest.edf', {'C5..'});
c1  = get_edfdata('data_rest.edf', {'C1..'});
cp3 = get_edfdata('data_rest.edf', {'Cp3.'});
fcz = get_edfdata('data_rest.edf', {'Fcz.'});
cpz = get_edfdata('data_rest.edf', {'Cpz.'});
fc4 = get_edfdata('data_rest.edf', {'Fc4.'});
c2  = get_edfdata('data_rest.edf', {'C2..'});
c6  = get_edfdata('data_rest.edf', {'C6..'});
cp4 = get_edfdata('data_rest.edf', {'Cp4.'});

c3  = get_edfdata('data_rest.edf', {'C3..'});
cz  = get_edfdata('data_rest.edf', {'Cz..'});
c4  = get_edfdata('data_rest.edf', {'C4..'});

rest = [c3 c4 cz ones(length(c3),1)];
rest = rest(1:9600,:);

% reading edf data for movement condition
c3 = get_edfdata('data_right.edf', {'C3..'});
c4 = get_edfdata('data_right.edf', {'C4..'});
cz = get_edfdata('data_right.edf', {'Cz..'});
move = [c3 c4 cz ones(length(c3),1)*2];
move = move(1:9600,:);

data = [rest; move];
save("test_data.mat", "data")

%% useful functions
function [signal] = get_edfdata(edf_path, name_col)
    original_signal = edfread(edf_path,'SelectedSignals', name_col);
    original_signal = table2array(original_signal);
    signal = vertcat(original_signal{:});
end
