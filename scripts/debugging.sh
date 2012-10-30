#!/bin/bash -x #-u

echo "Echoing undefined variable ${undefined}"

set -e
echo "checking for myfile.txt" # Create the myfile.txt and see what happens next.
test -f myfile.txt

set +e
echo "checking for myfile2.txt"
test -f myfile2.txt

echo "end of script"
