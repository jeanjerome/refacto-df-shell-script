#!/bin/bash

test_directory="./test"

find "$test_directory" -name "*test.sh" | while read -r test_file; do
    echo "Running tests in $test_file"
    bash "$test_file"
done