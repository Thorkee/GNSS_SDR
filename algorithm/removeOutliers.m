function [filteredInputFeatures, filteredOutputError] = removeOutliers(inputFeatures, outputError)
    [numData, numFeatures] = size(inputFeatures);
    Q1 = quantile(inputFeatures, 0.25);
    Q3 = quantile(inputFeatures, 0.75);
    IQR = Q3 - Q1;
    outlierIndices = false(numData, 1);
    for i = 1:numFeatures
        outlierIndices = outlierIndices | (inputFeatures(:, i) < (Q1(i) - 1.5 * IQR(i))) | (inputFeatures(:, i) > (Q3(i) + 1.5 * IQR(i)));
    end
    filteredInputFeatures = inputFeatures(~outlierIndices, :);
    filteredOutputError = outputError(~outlierIndices);
end
