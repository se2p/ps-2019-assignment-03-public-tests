#!/bin/bash

# Not 100% sure this is ok to check that last "Wrong" message of a lost game shows HD/SVD. Maybe we should check that the "right" lost message is shown?

OUTPUT_FILE=output

FAIL_MESSAGE="Wrong lost message"

SHOW_HD=$(cat ${OUTPUT_FILE} | grep ">> Wrong" | tail -1 | grep -c "HD")
SHOW_SVD=$(cat ${OUTPUT_FILE} | grep ">> Wrong" | tail -1 | grep -c "SVD")

if [ ! "${SHOW_HD}" -eq "0" -a ! "${SHOW_SVD}" -eq "0" ]; then
    >&2 echo "${FAIL_MESSAGE}"
fi
