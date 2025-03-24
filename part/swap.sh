# from https://github.com/i-abc/GB5/blob/main/gb5-test.sh, modified

##### 检测内存，增加Swap#####
add_swap(){
    _yellow "添加Swap任务开始，完成时间取决于硬盘速度，请耐心等候\n"
    need_swap=$((1500 - old_ms))
    # fallocate -l "$need_swap"M $dir/swap
    # fallocate在RHEL6、7上创建swap失败，见https://access.redhat.com/solutions/4570081
    dd if=/dev/zero of=$work_dir/swap bs=1M count=$need_swap
    chmod 0600 $work_dir/swap
    mkswap $work_dir/swap
    swapon $work_dir/swap

    # 再次判断内存+Swap是否小于1.5G
    new_swap=$(free -m | awk '/Swap/{print $2}')
    new_ms=$((mem + new_swap))
    if [ "$new_ms" -ge "1500" ]; then
        echo
        _blue "经判断，现在内存加Swap总计${new_ms}Mi，满足GB5测试条件\n"
    else
        echo
        echo "很抱歉，由于未知原因，Swap未能成功新增，现在内存加Swap总计${new_ms}Mi，后续将尽力尝试GeekBench测试"
    fi
}
check_swap() {
    # 检测内存
    mem=$(free -m | awk '/Mem/{print $2}')
    old_swap=$(free -m | awk '/Swap/{print $2}')
    old_ms=$((mem + old_swap))

    # 判断内存是否小于1G、或内存+Swap是否小于1.5G，若都小于则加Swap
    if [ "$mem" -ge "1024" ]; then
        return
    elif [ "$old_ms" -ge "1500" ]; then
        return
    else
        echo -n "经判断，本机内存小于1G，且内存加Swap总计小于1.5G，是否添加临时swap内存(y/n) "
        read -r choice_1
        echo -e "\033[0m"
        case "$choice_1" in
        n)
            return
            ;;
        # 添加swap
        y)
            add_swap
            ;;
        *)
            _red "未输入y/n，默认添加Swap"
            add_swap
            ;;
        esac
    fi
}