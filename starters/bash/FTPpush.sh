#!/bin/bash
FILE=$2
echo "file = $FILE"
FILE=${FILE/../.DOT.}
echo "file = $FILE"
cd $1
mv $2 $FILE
ftp -n <<EOF
open XXXXXXXXXXXXXXXXX
user dsailors daves123
passive
lcd $1
bin
!pwd
put $FILE
ls $FILE
quit
EOF
