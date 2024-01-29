#!/bin/bash

# shellcheck disable=SC1091
source "./test/test_wrapper.sh" 
# shellcheck disable=SC1091
source "${DF_PATH}"/lib/execute/stage_wrapper.sh

# Fonctions spécifiques aux tests
logic_function_that_should_works_ok() {
    ls -al
}

logic_function_that_should_exit_with_2() {
    ls -jj
}

# Test 1
execute_stage logic_function_that_should_works_ok
status=$?

validate_test_success $status

# Test 2
execute_stage logic_function_that_should_exit_with_2
status=$?

validate_test_failure $? 2
