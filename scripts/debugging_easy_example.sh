#!/bin/bash
 
if [ 4 -eq 4 ] then
  echo "hello"
fi

# Should produce:
# scripts/debugging_easy_example.sh: line 5: syntax error near unexpected token `fi'
# scripts/debugging_easy_example.sh: line 5: `fi'
