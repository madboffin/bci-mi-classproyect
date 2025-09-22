# Brain-Computer Interface (BCI) Motor Imagery Classification Project

This project implements a Brain-Computer Interface system that processes and classifies EEG (Electroencephalography) data, specifically focusing on motor imagery tasks. The system can distinguish between different mental states, such as rest state and right-hand motor imagery.

## Overview

This BCI system uses Common Spatial Pattern (CSP) filtering and machine learning techniques to process EEG signals and classify different mental states. It's designed for both offline analysis of EEG data and potential real-time applications.

## Project Structure

- `data_rest.edf` & `data_right.edf`: EEG data files containing recordings for rest state and right-hand motor imagery
- `main_train.m`: Main training script for the classification model
- `get_features.m`: Feature extraction from EEG signals
- `get_class.m`: Classification functionality
- `create_filtb5.m`: Filter creation for signal processing
- `edfread2.m`: Utility for reading EDF (European Data Format) files
- `send_msg.m`: Communication interface
- `Model_0.mat`: Trained model file

### CSP Implementation
Located in the `CSP_Mathworks/` directory:
- `csp.m`: Common Spatial Pattern implementation
- `csp_example.m`: Example usage of CSP

### Simplified Scripts
Located in `Scripts simplificados/`:
- `EegSingleRecord.m`: Single EEG recording functionality
- `OnlineRecord.m`: Real-time EEG recording capabilities

## Prerequisites

- MATLAB
- EEG Data Processing Toolbox
- Signal Processing Toolbox

## Usage

1. Data Processing:
   - Use `edfread2.m` to load EEG data files
   - Apply filters created by `create_filtb5.m`
   - Extract features using `get_features.m`

2. Training:
   - Run `main_train.m` to train the classification model
   - The trained model will be saved as `Model_0.mat`

3. Classification:
   - Use `get_class.m` for classifying new EEG signals

## Technical Details

The project uses Common Spatial Pattern (CSP) filtering for spatial feature extraction from multichannel EEG data. This technique is particularly effective for motor imagery classification as it maximizes the variance differences between two classes of EEG signals.

## File Descriptions

- `create_test_array.m`: Creates test arrays for validation
- `filter_coef.mat`: Contains filter coefficients
- `test_data.mat`: Test dataset
- `test_easy.easy`: Simplified test case

## Contributing

Feel free to fork this repository and submit pull requests for any improvements.

## License

Please refer to the license file in the CSP_Mathworks directory for specific terms regarding the CSP implementation.