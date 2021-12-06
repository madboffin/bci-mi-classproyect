
function predicted_class = main_classify(features)
    load('Model_0 .mat','cl_lda')
    [~,ypredicted] = predict( cl_lda, features );

    % for lda classifier
    if ypredicted >= 0.5
        predicted_class = 1;
    elseif ypredicted < 0.5
        predicted_class = 0;
    end
    

end