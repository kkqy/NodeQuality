#!/bin/bash

echo "三网回程检测，感谢 https://github.com/oneclickvirt/nt3 "

curl https://raw.githubusercontent.com/oneclickvirt/nt3/main/nt3_install.sh -sSf | bash &> /dev/null
./nt3 | tail -n +3
