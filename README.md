# MATLAB Code for GNSS Multipath Classification
## Functions:
1. Loads the dataset and extracts input features and output error.
2. Normalizes the input features for better model performance.
3. Removes outliers from the input features and output error using the IQR method.
4. Splits the dataset into training, validation, and testing sets.
5. Performs feature importance analysis using the ReliefF algorithm.
6. Builds a 1D Convolutional Neural Network (CNN) model for regression.
7. Trains the CNN model using the training and validation sets.
8. Evaluates the trained model on the training and test sets, calculating Mean Squared Error (MSE), Mean Absolute Error (MAE), Root Mean Squared Error (RMSE), and Median Absolute Error (MedAE).
9. Plots the true vs. predicted errors scatter plot for the training and test sets.
10. Plots the error distribution histogram for the training and test sets.

## Note:
1. It is only a very prelimentary code, bugs are unavoidable.
2. ReliefF comes from external source.
3. Dataset are pending to be uploaded.
