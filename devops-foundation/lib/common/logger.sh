#!/bin/sh
 
DEBUG_LEVEL=0
INFO_LEVEL=1
WARN_LEVEL=2
SUCCESS_LEVEL=3
ERROR_LEVEL=4
 
LOG_LEVEL=${LOG_LEVEL:-$INFO_LEVEL}
# shellcheck disable=SC3030
LOG_LEVELS=(DEBUG INFO WARN SUCCESS ERROR)
 
START_COLOR_PREFIX="\e[0;"
START_COLOR_SUFFIX="m"
END_COLOR="\e[0m"
 
DEBUG_COLOR="${START_COLOR_PREFIX}90${START_COLOR_SUFFIX}" # grey
INFO_COLOR="${START_COLOR_PREFIX}34${START_COLOR_SUFFIX}" # blue
WARN_COLOR="${START_COLOR_PREFIX}33${START_COLOR_SUFFIX}" #yellow
SUCCESS_COLOR="${START_COLOR_PREFIX}32${START_COLOR_SUFFIX}" # green
ERROR_COLOR="${START_COLOR_PREFIX}31${START_COLOR_SUFFIX}" # red
 
logDebug()
{
    if [ -n "$1" ]; then
      __log "${DEBUG_COLOR}" "${DEBUG_LEVEL}" "$1"
    else
      log_stream "${DEBUG_COLOR}" "${DEBUG_LEVEL}"
    fi
}
 
logInfo()
{
  if [ -n "$1" ]; then
    __log "${INFO_COLOR}" "${INFO_LEVEL}" "$1"
  else
    log_stream "${INFO_COLOR}" "${INFO_LEVEL}"
  fi
}
 
logSuccess()
{
  if [ -n "$1" ]; then
    __log "${SUCCESS_COLOR}" "${SUCCESS_LEVEL}" "$1"
  else
    log_stream "${SUCCESS_COLOR}" "${SUCCESS_LEVEL}"
  fi
}
 
logWarn()
{
  if [ -n "$1" ]; then
    __log "${WARN_COLOR}" "${WARN_LEVEL}" "$1"
  else
    log_stream "${WARN_COLOR}" "${WARN_LEVEL}"
  fi
}
 
logError()
{
  if [ -n "$1" ]; then
    __log "${ERROR_COLOR}" "${ERROR_LEVEL}" "$1"
  else
    log_stream "${ERROR_COLOR}" "${ERROR_LEVEL}"
  fi
}
 
log_stream() {
  # shellcheck disable=SC3043
  local start_color="$1"
  # shellcheck disable=SC3043
  local level="$2"
 
  while IFS= read -r content; do
    __log "$start_color" "$level" "${content}"
  done
}
 
# print message
__log() {
  # shellcheck disable=SC3043
  local start_color="$1"
  # shellcheck disable=SC3043
  local level="$2"
  # shellcheck disable=SC3043
  local content="$3"
 
  [ ! -d "${LOG_PATH}" ] && mkdir -p "${LOG_PATH}"
 
  # shellcheck disable=SC3054
  if [ -n "$level" ] && [ "$LOG_LEVEL" -le "$level" ]; then
 
    level="[${LOG_LEVELS[$level]}]"
    if [ "${LOGGER_COLORIZED_ENABLED}" = "true" ]; then
      printf "%b%s %s%b\n" "$start_color" "$level" "$content" "$END_COLOR" | tee -a "${LOG_PATH}/stderr.log" >&2
    else
      printf "%s %s\n" "$level" "$content" | tee -a "${LOG_PATH}/stderr.log" >&2
    fi
 
  elif [ -z "$level" ]; then
 
    printf "%s\n" "$content" | tee -a "${LOG_PATH}/stderr.log" >&2
 
  fi
}
 