function create_test_array(fs)
% info = edfinfo(filename);
% filename = 'data_rest.edf';
%% reading edf data for resting condition
filename = uigetfile({'*.easy';'*.edf'})
[cz,c3,c4] = get_data(filename,fs);

rest = [ c3 c4 cz ones(length(c3),1)*0 ];
rest = rest(1*fs:20*fs,:);

%% reading edf data for movement condition
filename = uigetfile({'*.easy';'*.edf'})
[cz,c3,c4] = get_data(filename,fs);

move = [ c3 c4 cz ones(length(c3),1)*1 ];
move = move(1*fs:20*fs,:);

% figure
% subplot(211), plot(rest(:,1))
% subplot(211), plot(move(:,1))
%% combining data into a single file
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
        c3  = data{1}(5*fs:25*fs);  % 15
        c4  = data{2}(5*fs:25*fs);  % 11
    else
        error('file extension not available, use a edf or easy file')
    end
end
