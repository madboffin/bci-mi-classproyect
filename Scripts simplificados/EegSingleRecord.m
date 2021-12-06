function [eeg, marker, timestamp] = EegSingleRecord(nChannels, useTriggers, useTimestamps, ch)
    eeg = 0;
    marker = 0;
    timestamp = 0;
    import java.io.*
    import java.nio.*
    bytes = ByteBuffer.allocate(nChannels*4);
    bytes.order(ByteOrder.LITTLE_ENDIAN);
    n_bytes = 0;
    while n_bytes < nChannels*4
        n_bytes = n_bytes + ch.read(bytes);
    end
    text = typecast(int8(bytes.array())', 'int32' );
    eeg = reshape(text, [nChannels, 1])';
    if useTriggers
        bytes = ByteBuffer.allocate(4);
        bytes.order(ByteOrder.LITTLE_ENDIAN);
        n_bytes = 0;
        while n_bytes < 4
            n_bytes = n_bytes + ch.read(bytes);
        end
        marker = typecast(int8(bytes.array())', 'int32' );
    end
    if useTimestamps
        bytes = ByteBuffer.allocate(8);
        bytes.order(ByteOrder.LITTLE_ENDIAN);
        n_bytes = 0;
        while n_bytes < 8
            n_bytes = n_bytes + ch.read(bytes);
        end
        timestamp = typecast(int8(bytes.array())', 'int64' );
    end
end