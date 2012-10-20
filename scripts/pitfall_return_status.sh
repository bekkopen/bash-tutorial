#!/bin/bash

cat users.txt | sort | uniq

echo "return status is $?"

u=$(cat users.txt) && echo $u | sort | uniq
echo "return status is $?"
