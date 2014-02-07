#!/bin/bash

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $BASEDIR

# Syntax check
echo "Running syntax check ..."
scripts=$(ls -1 *.sh ../include/*.sh)

for script in ${scripts[@]}
do
  echo "checking ${script}"
  bash -n ${script} || exit 1
done
echo "Syntax check finished ..."

# Tests
echo "Running tests ..."
tests=$(ls -1 ../tests/test*.sh )

for test in ${tests[@]}
do
  echo "running ${test}"
  ${test} || exit 1
done
echo "Tests finished ..."
exit 0
