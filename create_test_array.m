function create_test_array(fs)
% info = edfinfo(filename);
% filename = 'data_rest.edf';
%% reading edf data for resting condition
filename = uigetfile({'*.edf';'*.easy'});
[cz,c3,c4] = get_data(filename,fs);

rest = [ c3 c4 cz ones(length(c3),1)*0 ];
rest = rest(1:20*fs,:);

%% reading edf data for movement condition
filename = uigetfile({'*.edf';'*.easy'});
[cz,c3,c4] = get_data(filename,fs);

move = [ c3 c4 cz ones(length(c3),1)*1 ];
move = move(1:20*fs,:);

%% combining data into a single file
size(rest), size(move)
data = [rest; move];
save("test_data.mat", "data")
end

%% useful functions
function [signal] = get_edfdata(edf_path, name_col)
    original_signal = edfread(edf_path,'SelectedSignals', name_col);
    original_signal = table2array(original_signal);
    signal = vertcat(original_signal{:});
end

function [cz,c3,c4] = get_data(filename,fs)

    % detects file type 
    [~,~,ext] = fileparts(filename);

    if strcmp(ext,'.edf')
        cz  = get_edfdata(filename, {'Cz..'});
        cz = cz((5*fs:25*fs));
        c3  = get_edfdata(filename, {'C3..'});
        c3 = c3((5*fs:25*fs));
        c4  = get_edfdata(filename, {'C4..'});
        c4 = c4((5*fs:25*fs));
    elseif strcmp(ext,'.easy')
        % careful, struct might change channel position
        data = struct2cell( tdfread(filename) );
        cz  = data{3}(5*fs:25*fs);
        c3  = data{15}(5*fs:25*fs);
        c4  = data{11}(5*fs:25*fs);
    else
        error('file extension not available, use a edf or easy file')
    end
end

% for laplacian filter (taking mean of surrounding electrodes)
% fc3 = get_edfdata(filename, {'Fc3.'});
% c5  = get_edfdata(filename, {'C5..'});
% c1  = get_edfdata(filename, {'C1..'});
% cp3 = get_edfdata(filename, {'Cp3.'});
% fcz = get_edfdata(filename, {'Fcz.'});
% cpz = get_edfdata(filename, {'Cpz.'});
% fc4 = get_edfdata(filename, {'Fc4.'});
% c2  = get_edfdata(filename, {'C2..'});
% c6  = get_edfdata(filename, {'C6..'});
% cp4 = get_edfdata(filename, {'Cp4.'});
