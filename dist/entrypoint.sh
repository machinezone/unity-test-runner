#!/usr/bin/env bash

#
# Create directory for license activation
#

ACTIVATE_LICENSE_PATH="$GITHUB_WORKSPACE/_activate-license"
mkdir -p "$ACTIVATE_LICENSE_PATH"

#
# Run steps
#

source /steps/activate.sh
source /steps/set_gitcredential.sh
source /steps/run_tests.sh
source /steps/return_license.sh

#
# Remove license activation directory
#

rm -r "$ACTIVATE_LICENSE_PATH"

#
# Configure ssh
#

mkdir -m 700 -p ~/.ssh && echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config

#
# Instructions for debugging
#

# TODO we get some strange "crashes" where everything ran correctly but still exited non-zero,
# so for now ignore the test runner exit code. see https://github.com/game-ci/unity-test-runner/issues/216
IGNORE_TEST_RUNNER_EXIT_CODE=true

if [[ $IGNORE_TEST_RUNNER_EXIT_CODE != true ]]; then
    if [[ $TEST_RUNNER_EXIT_CODE -gt 0 ]]; then
    echo ""
    echo "###########################"
    echo "#         Failure         #"
    echo "###########################"
    echo ""
    echo "Please note that the exit code is not very descriptive."
    echo "Most likely it will not help you solve the issue."
    echo ""
    echo "To find the reason for failure: please search for errors in the log above."
    echo ""
    fi;

    #
    # Exit with code from the build step.
    #

    if [[ $USE_EXIT_CODE == true || $TEST_RUNNER_EXIT_CODE -ne 2 ]]; then
    exit $TEST_RUNNER_EXIT_CODE
    fi;
fi
