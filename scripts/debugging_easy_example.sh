#!/bin/bash
 
if [ 4 -eq 4 ] then
  echo "hei"
fi

# Should produce:
# ./test.sh: line 5: syntax error near unexpected token `fi'
# ./test.sh: line 5: `fi'
