#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for file in *.sql; do
    python $SCRIPT_DIR/../runSQL.py $file > ${file%.*}.out
done
