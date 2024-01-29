#!/bin/bash

# shellcheck disable=SC1091
source "${DF_PATH}"/lib/execute/command_wrapper.sh
# shellcheck disable=SC1091
source "${DF_PATH}/lib/common/logger.sh"
# shellcheck disable=SC1091
source "${DF_PATH}"/lib/common/common.sh

source_dependencies() {
    if [[ -n $DEPENDENCIES_FILES ]]; then
        for file in "${DEPENDENCIES_FILES[@]}"; do
            if [[ -f $file ]]; then
                logDebug "Sourcing file:${file}..."
                # shellcheck disable=SC1090
                . "$file"
            else
                logError "Unable to source dependency file '$file'"
            fi
        done
    fi
}

execute_stage() {
    local stage_logic_function="$1"
    shift
    local parameters=("$@")

    source_dependencies

    # shellcheck disable=SC2046
    execute_command pre_operation || return $(handle_exit_status $? pre_operation)

    logDebug "Executing stage logic..."
    # shellcheck disable=SC2046 disable=SC2086
    execute_command "$stage_logic_function" "${parameters[@]}" || return $(handle_exit_status $? ${stage_logic_function})
    
    # shellcheck disable=SC2046
    execute_command post_operation || return $(handle_exit_status $? post_operation)
}

handle_exit_status() {
    local status="$1"
    local function_name="$2"

    logDebug "Handling stage error for function:${function_name} with status:${status}"

    if [ "$status" -ne "0" ] && [ "$status" -ne "1" ]; then
        exit 2
    else
        # shellcheck disable=SC2086
        return $status
    fi
}
