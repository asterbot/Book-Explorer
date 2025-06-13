#!/bin/bash

echo "Deleting existing venv"
rm -rf venv/

echo "Setting up venv"
python3 -m venv venv/
if [ $? -ne 0 ]; then
    echo "venv setup failed"
    exit 1
fi

echo "Activating venv"
source venv/bin/activate

echo "Installing requirements"
pip install -r requirements.txt
