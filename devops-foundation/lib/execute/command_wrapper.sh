#!/bin/bash

# shellcheck disable=SC1091
source "${DF_PATH}/lib/common/logger.sh"
 
execute_command() {
    local command=("$@")
    # shellcheck disable=SC2155
    local command_logfile=$(mktemp "${LOG_PATH}/XXXXXXXX.tmp")
 
    logDebug "Executing command: ${command[*]}"
 
    local output exit_code
    # shellcheck disable=SC2068
    output=$(${command[@]} 2> "$command_logfile")
    exit_code=$?
 
    hanle_command_error "$exit_code" "$command_logfile" "${command[*]}"
 
    rm "${command_logfile}"
    echo "$output"
    return $exit_code
}
 
hanle_command_error() {
    local exit_code="$1"
    local command_logfile="$2"
    shift 2
    local command=("$@")
    
 
    logDebug "Handling error for exit code:${exit_code}, command=${command[*]}, stderr_file:${command_logfile}."
 
    if [ "$exit_code" -ne "0" ] && [ "$TEST_CONTEXT" != "true" ]; then
        logError "Command: '${command[*]}' returns status code: ${exit_code}."
        logDebug < "${command_logfile}"
    fi
}