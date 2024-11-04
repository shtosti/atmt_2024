#!/bin/bash

# Run training
echo "Running training script..."
./train_model_3.sh

# Check if trainining was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running train_model_3.sh"
    exit 1
fi


# Run translation
echo "Running translation script..."
./translate_3.sh

# Check if translation was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running translate_3.sh"
    exit 1
fi


# Run postprocessing
echo "Running postprocess script..."
./postprocess_3.sh

# Check if postprocessing was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running postprocess_3.sh"
    exit 1
fi


# Run evaluation
echo "Running evaluation script..."
./evaluate_3.sh

# Check if evaluate.sh was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running evaluate_3.sh"
    exit 1
fi


echo "All scripts executed successfully!"
