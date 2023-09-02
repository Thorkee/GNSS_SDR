dataset = load('JU_MLMODEL_TRAINING_DATASET.mat');

% Extract features and output
inputFeatures = [dataset.Time, dataset.SatelliteNo, dataset.E_i, dataset.E_q, dataset.P_i, dataset.P_q, dataset.L_i, dataset.L_q, dataset.CN0, dataset.Correlation];
outputError = dataset.Error;

% Normalization
normalizedInputFeatures = (inputFeatures - min(inputFeatures, [], 1)) ./ (max(inputFeatures, [], 1) - min(inputFeatures, [], 1));

% Outlier Removal
[filteredInputFeatures, filteredOutputError] = removeOutliers(normalizedInputFeatures, outputError);

% Training/Testing/Validation Split
trainRatio = 0.7;
validationRatio = 0.15;
testRatio = 0.15;

[XTrain, YTrain, XValidation, YValidation, XTest, YTest] = splitDataset(filteredInputFeatures, filteredOutputError, trainRatio, validationRatio, testRatio);

% ReliefF-based FIA
rankedFeatures = relieff(XTrain, YTrain, 10);

% Ranking Results
fprintf('Feature rankings (from most to least important):\n');
for i = 1:length(rankedFeatures)
    fprintf('%d\n', rankedFeatures(i));
end

% CNN Regression
numFeatures = size(XTrain, 2);

filterSize = 3;
numFilters = 32;
poolSize = 2;
stride = 2;

layers = [
    sequenceInputLayer(numFeatures)
    convolution1dLayer(filterSize, numFilters, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(poolSize, 'Stride', stride)
    dropoutLayer(0.5)
    fullyConnectedLayer(64)
    reluLayer
    dropoutLayer(0.5)
    fullyConnectedLayer(1)
    regressionLayer];

options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 128, ...
    'ValidationData', {XValidation, YValidation}, ...
    'ValidationFrequency', 30, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

net = trainNetwork(XTrain, YTrain, layers, options);

% Training Set Evaluation
YPredTrain = predict(net, XTrain);
mseTrain = mean((YPredTrain - YTrain).^2);
maeTrain = mean(abs(YPredTrain - YTrain));
rmseTrain = sqrt(mseTrain);
medaeTrain = median(abs(YPredTrain - YTrain));

% Testing Set Evaluation
YPredTest = predict(net, XTest);
mseTest = mean((YPredTest - YTest).^2);
maeTest = mean(abs(YPredTest - YTest));
rmseTest = sqrt(mseTest);
medaeTest = median(abs(YPredTest - YTest));

% Print the evaluation metrics for the training set
fprintf('Training Set:\n');
fprintf('MSE: %.4f\n', mseTrain);
fprintf('MAE: %.4f\n', maeTrain);
fprintf('RMSE: %.4f\n', rmseTrain);
fprintf('MedAE: %.4f\n', medaeTrain);

% Evaluation Result Print
fprintf('Test Set:\n');
fprintf('MSE: %.4f\n', mseTest);
fprintf('MAE: %.4f\n', maeTest);
fprintf('RMSE: %.4f\n', rmseTest);
fprintf('MedAE: %.4f\n', medaeTest);

%Training Set Plots
% True vs. Predicted Errors Plot
figure;
scatter(YTrain, YPredTrain);
xlabel('True Errors');
ylabel('Predicted Errors');
title('True vs. Predicted Errors (Training Set)');

% Error Distribution Plot
figure;
histogram(YTrain - YPredTrain, 50);
xlabel('Error');
ylabel('Frequency');
title('Error Distribution (Training Set)');

%Test Set Plots
% True vs. Predicted Errors Plot
figure;
scatter(YTest, YPredTest);
xlabel('True Errors');
ylabel('Predicted Errors');
title('True vs. Predicted Errors (Test Set)');

% Error Distribution Plot
figure;
histogram(YTest - YPredTest, 50);
xlabel('Error');
ylabel('Frequency');
title('Error Distribution (Test Set)');

