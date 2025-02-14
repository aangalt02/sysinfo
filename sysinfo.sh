clear
width=55
line=$(printf '=%.0s' $(seq 1 $width))

center_text() {
    text="$1"
    padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

echo "$line"
center_text "SYSTEM INFO"
echo "$line"
sleep 0.5
printf "| %-*s |\n" $((width-2)) "OS       : $(lsb_release -d 2>/dev/null | cut -f2 || grep PRETTY_NAME /etc/os-release | cut -d '\"' -f2)"
sleep 0.5
printf "| %-*s |\n" $((width-2)) "CPU      : $(grep -m1 'model name' /proc/cpuinfo | cut -d ':' -f2 | xargs)"
sleep 0.5
printf "| %-*s |\n" $((width-2)) "RAM      : $(free -h | awk '/Mem:/ {print $2}')"
sleep 0.5
printf "| %-*s |\n" $((width-2)) "Storage  : $(lsblk -d -o SIZE -n | awk '{sum += $1} END {print sum "G"}')"
echo "$line"

center_text "NETWORK INFO"
echo "$line"
sleep 0.5

ip -o link show | awk -F': ' '{print $2}' | while read interface; do
    ip_addr=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
    mac_addr=$(ip link show "$interface" | awk '/ether/ {print $2}')
    if [[ -n "$mac_addr" ]]; then
        printf "| %-*s |\n" $((width-2)) "Interface: $interface"
        printf "| %-*s |\n" $((width-2)) "  IP Addr : ${ip_addr:-N/A}"
        printf "| %-*s |\n" $((width-2)) "  MAC Addr: $mac_addr"
        echo "$line"
    fi
done

