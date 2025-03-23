#!/bin/bash

HEADING_DATE="$(TZ='Asia/Shanghai' date +'%Y-%m-%d %H:%M:%S CST')"
echo -ne "\e[0;36m"
cat <<-EOF
########################################################################
                  bash <(curl -sL https://run.NodeQuality.com)
                   https://github.com/LloydAsp/NodeQuality
        报告时间：$HEADING_DATE  脚本版本：v0.0.1
        频道: https://t.me/nodeselect 网站：https://NodeQuality.com
########################################################################
EOF
echo -ne "\033[0m"