#!/bin/bash


# Run translate.sh
echo "Running translation script..."
./translate.sh

# Check if translate.sh was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running translate.sh"
    exit 1
fi


# Run postprocess.sh
echo "Running postprocess script..."
./postprocess.sh

# Check if postprocess.sh was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running postprocess.sh"
    exit 1
fi


# Run evaluate.sh
echo "Running evaluation script..."
./evaluate.sh

# Check if evaluate.sh was successful
if [ $? -ne 0 ]; then
    echo "Error occurred while running evaluate.sh"
    exit 1
fi


echo "All scripts executed successfully!"
