#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Provide username as argument"
    echo "Usage: ./generate_outputs.sh [username]"
    exit 1
fi

for file in *.sql; do
    mysql -u $1 --table cs348_project -p < $file > ${file%.*}.out
done
