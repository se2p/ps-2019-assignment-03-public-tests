#!/bin/bash

# Use default names instead of parameters
EXPECTED_OUTPUT_FILE=expected.output
OUTPUT_FILE=output

FAIL_MESSAGE="Secret code does not have four digits"

# Check output by diff >> Guess the 4-digit secret code (7):
if [ $(cat ${OUTPUT_FILE} | grep "digit" | sed 's/>> Guess the \(.*\)-digit.*/\1/' | grep -vc 4) -gt 0 ]; then
   >&2 echo "${FAIL_MESSAGE}"
fi

