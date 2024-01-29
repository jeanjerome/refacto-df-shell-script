#!/bin/bash

# shellcheck disable=SC1091
source "./test/test_wrapper.sh" 
# shellcheck disable=SC1091
source "${DF_PATH}/lib/execute/command_wrapper.sh"

# Test 1
command_line="mvn -B -f ${WORKSPACE} org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout"
output=$(execute_command "$command_line")
status=$?

validate_test_success $status
validate_test "$output" "1.0.0-SNAPSHOT"

# Test 2
command_line="ls -alj"
execute_command "$command_line"
status=$?

validate_test_failure $? 2