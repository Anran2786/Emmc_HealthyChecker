life_time=$(cat /sys/class/mmc_host/mmc0/mmc0:0001/life_time)
clear

echo "\033[1;36m███████╗\033[31m███╗   ███╗███╗   ███╗ ██████╗";
echo "\033[1;36m██╔════╝\033[31m████╗ ████║████╗ ████║██╔════╝";
echo "\033[1;36m█████╗  \033[31m██╔████╔██║██╔████╔██║██║";
echo "\033[1;36m██╔══╝  \033[31m██║╚██╔╝██║██║╚██╔╝██║██║";
echo "\033[1;36m███████╗\033[31m██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╗";
echo "\033[1;36m╚══════╝\033[31m╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝\033[0m";
echo "\033[32m██╗  ██╗\033[33m ██████╗██╗  ██╗██╗  ██╗███████╗██████╗ ";
echo "\033[32m██║  ██║\033[33m██╔════╝██║  ██║██║ ██╔╝██╔════╝██╔══██╗";
echo "\033[32m███████║\033[33m██║     ███████║█████╔╝ █████╗  ██████╔╝";
echo "\033[32m██╔══██║\033[33m██║     ██╔══██║██╔═██╗ ██╔══╝  ██╔══██╗";
echo "\033[32m██║  ██║\033[33m╚██████╗██║  ██║██║  ██╗███████╗██║  ██║";
echo "\033[32m╚═╝  ╚═╝\033[33m ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝\033[0m";
echo "                                                ";

life_type_a=$(echo $life_time | awk '{print $1}')
life_type_b=$(echo $life_time | awk '{print $2}')
life_type_a_dec=$((16#${life_type_a#0x}))
life_type_b_dec=$((16#${life_type_b#0x}))
# 0为未汇报
# 1为0-10
# 2为10-20
# 3为20-30
# 4为30-40
# 5为40-50
# 6为50-60
# 7为60-70
# 8为70-80
# 9为80-90
# 10为90-100
# 11要寄了
if [ "$life_type_a_dec" -gt "$life_type_b_dec" ]; then
    true_life_time=$life_type_a_dec
else
    true_life_time=$life_type_b_dec
fi
if [ $true_life_time -gt 10 ]; then
    echo "\033[41m                               "
    echo " 设备eMMC寿命已耗尽，请随时做好最坏打算 "
    echo "                               "
elif [ $true_life_time -eq 0 ]; then
    echo "\033[45m                        "
    echo " 设备eMMC未报告寿命信息 "
    echo "                        \033[0m"
    exit 0
else
    print_true_life_time=$true_life_time
fi
life_percent_min=$(( (print_true_life_time - 1) * 10 ))
life_percent_max=$(( print_true_life_time * 10 ))
 
if [ $true_life_time -lt 4 ] && [ $true_life_time -gt 0 ]; then
    color="\033[42m"
elif [ $true_life_time -lt 8 ] && [ $true_life_time -ge 4 ]; then
    color="\033[43m"
else color="\033[41m"
fi

echo "${color}                             "  
echo "  设备eMMC寿命已使用$life_percent_min%~$life_percent_max%  "
echo "                             \033[0m"

#必样的累了，回头再补下面这一坨
echo "\033[35m———————————————————————————————————————————"
pre_eol_info=$(cat /sys/class/mmc_host/mmc0/mmc0:0001/pre_eol_info)
if [ "$pre_eol_info" = "01" ]; then
    echo "|设备eMMC未进入预警状态，保留区块已用0~80%|"
elif [ "$pre_eol_info" = "02" ]; then
    echo 设备eMMC已进入预警状态，保留区块已用80~90%
elif [ "$pre_eol_info" = "03" ]; then
    echo 设备eMMC已进入临界状态，保留区块已用90~100%
else
    echo 设备eMMC未报告预警信息
fi
echo "———————————————————————————————————————————\033[0m"

#sui:喵喵
#soraneko:喵喵 ww

echo  
echo 其它信息：
echo "-------------------------------------"
date=$(cat /sys/class/mmc_host/mmc0/mmc0:0001/date)
eMMC_vendor=$(cat /sys/class/mmc_host/mmc0/mmc0:0001/cid | awk '{print substr($1,1,2)}')
if [ "$eMMC_vendor" = "15" ]; then
    eMMC_vendor="三星"
elif [ "$eMMC_vendor" = "11" ]; then
    eMMC_vendor="东芝"
elif [ "$eMMC_vendor" = "FE" ]; then
    eMMC_vendor="美光"
elif [ "$eMMC_vendor" = "90" ]; then
    eMMC_vendor="海力士"
elif [ "$eMMC_vendor" = "70" ]; then
    eMMC_vendor="金士顿"
else
    eMMC_vendor="未收录"
fi
date_year=$(echo $date | awk '{print substr($1,4,7)}')
date_month=$(echo $date | awk '{print substr($1,1,2)}')
echo "生产日期：$date_year年$date_month月"
echo "生产厂家：$eMMC_vendor"
echo "型号：$(cat /sys/class/mmc_host/mmc0/mmc0:0001/name)"
echo "CID：$(cat /sys/class/mmc_host/mmc0/mmc0:0001/cid)"
echo "-------------------------------------"