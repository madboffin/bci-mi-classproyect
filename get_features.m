function v_features = get_features(data,fs)
    v_features = [];
    mu = [ 9,14];
    be = [15,25];
    
    pSM = bandpower(data);
    pBe = bandpower(data,fs,be);
    pMu = bandpower(data,fs,mu);
    pBe_r = pBe/bandpower(data);
    pMu_r = pMu/bandpower(data);

    % order of features array
    v_features = [pSM pBe pMu pBe_r pMu_r];
end