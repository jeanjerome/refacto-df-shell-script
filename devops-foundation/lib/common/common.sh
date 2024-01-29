#!/bin/bash

pre_operation() {
  set -o pipefail
  logInfo "pre_operation function definition"
  
  #Create folder file for looging
  mkdir -p "$LOG_PATH"
}

post_operation() {
  logInfo "post_operation function definition"
}