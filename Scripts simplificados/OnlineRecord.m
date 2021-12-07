clc, clear, close all

import java.io.*
import java.nio.*

socket_ok = true;
record_duration = 100;  % in seconds
fs = 500;

try
    sock = java.net.Socket('localhost', 1234);
catch
    disp('Error creating socket');
    socket_ok = false;
end
if socket_ok
    cnt = 0;
    samples = 0;
    v_eeg = [];
    v_markers = [];
    v_timestamps = [];
    load("filter_coef.mat")  % b,a

    ch = channels.Channels.newChannel(sock.getInputStream);
    disp('Please wait...')
    
%     a = tic;
    while (samples <= (fs*record_duration))
        [eeg, marker, timestamp] = EegSingleRecord(32, false, true, ch);
        eeg = double(eeg);

        window  = 1.0*fs;
        overlap = 0.9*fs;
        v_eeg = [v_eeg ; eeg];
        v_markers = [v_markers;marker];
        v_timestamps = [v_timestamps;timestamp];

        c3 = v_eeg(:,18);
        c4 = v_eeg(:,11);
        cz = v_eeg(:,14);
        
        if (samples < window)
            c3_v = [zeros(window-samples,1); c3];
            c4_v = [zeros(window-samples,1); c4];
            cz_v = [zeros(window-samples,1); cz];
        else
            c3_v = c3(end-499:end);
            c4_v = c4(end-499:end);
            cz_v = cz(end-499:end);

            cnt = cnt +1;
            if ( cnt == (window-overlap) )
                c3_v = filtfilt(b,a,c3_v);
                c4_v = filtfilt(b,a,c4_v);
                cz_v = filtfilt(b,a,cz_v);

                % getting features
                c3_feat = get_features(c3_v,fs);
                c4_feat = get_features(c4_v,fs);
                cz_feat = get_features(cz_v,fs);
                
                % chaining features, sorting is important
                chann_features = [c3_feat c4_feat cz_feat];

                % classify
                class = main_classify(chann_features);

                % send command to unity
                if class == 0
                    send_msg("down");
                elseif class ==1
                    send_msg("up");
                end
                cnt = 0;
            end
        end
        
        % plotting array
        figure(1)
        c3_v = filtfilt(b,a,c3_v);
        cz_v = filtfilt(b,a,cz_v);
        c4_v = filtfilt(b,a,c4_v);
        subplot(311), plot(cz_v)
        subplot(312), plot(c3_v)
        subplot(313), plot(c4_v)

        % updating total samples
        samples = samples+1;
    end
%     toc(a)
    sock.close;
end
