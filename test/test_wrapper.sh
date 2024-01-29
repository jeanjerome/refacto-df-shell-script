#!/bin/bash

# Test environment configuration
export WORKSPACE="./workspace"
export LOG_PATH="./log"
export DF_PATH="./devops-foundation"
export LOGGER_COLORIZED_ENABLED="true"
export LOG_LEVEL=0

export TEST_CONTEXT="true"

# shellcheck disable=SC1091
source "${DF_PATH}"/lib/common/logger.sh
# shellcheck disable=SC1091
source "${DF_PATH}"/lib/execute/command_wrapper.sh

# Validate mandatory environment settings
validate_paths() {
    if [[ ! -d $WORKSPACE ]] || [[ ! -d $LOG_PATH ]] || [[ ! -d $DF_PATH ]]; then
        logError "One or more required directories do not exist."
        exit 1
    fi
}

clean_logs() {
    rm -rf "${LOG_PATH}"
    mkdir -p "${LOG_PATH}"
}

validate_test_success() {
    local status=$1

    validate_test "$status" 0
}

validate_test_failure() {
    local actual=$1
    local expected=$2

    validate_test "$status" "$expected"
}

validate_test() {
    local actual=$1
    local expected=$2
    
    if [ "$actual" == "$expected" ]; then
        logSuccess "Test Passed"
    else
        logError "Test Failed - Got ${actual} but ${expected} was expected"
        return 1
    fi
}

# Setup before running any test
validate_paths
clean_logs
