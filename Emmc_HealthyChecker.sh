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

life_time=$(cat /sys/class/mmc_host/mmc0/mmc0:0001/life_time)
life_type_a=$(echo $life_time | awk '{print $1}')
life_type_b=$(echo $life_time | awk '{print $2}')
life_type_a_dec=$((16#${life_type_a#0x}))
life_type_b_dec=$((16#${life_type_b#0x}))
if [ "$life_type_a_dec" -gt "$life_type_b_dec" ]; then
    true_life_time=$life_type_a_dec
else
    true_life_time=$life_type_b_dec
fi
if [ $true_life_time -gt 10 ]; then
    echo 设备eMMC寿命已耗尽，请随时做好最坏打算
elif [ $true_life_time -lt 1 ]; then
    echo 设备未报告寿命信息
else
    print_true_life_time=$true_life_time
fi
life_percent_min=$(( (print_true_life_time - 1) * 10 ))
life_percent_max=$(( print_true_life_time * 10 ))
echo "---------------------------"  
echo "/设备eMMC寿命已使用$life_percent_min%~$life_percent_max%/"
echo "---------------------------"  
sleep 20