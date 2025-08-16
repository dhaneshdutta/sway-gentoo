#!/bin/bash

cpu_usage() {
    read cpu a b c idle rest < /proc/stat
    prev_idle=$idle
    prev_total=$((a+b+c+idle))
    sleep 1
    read cpu a b c idle rest < /proc/stat
    idle_diff=$((idle - prev_idle))
    total_diff=$((a+b+c+idle - prev_total))
    usage=$((100 * (total_diff - idle_diff) / total_diff))
    echo "CPU: ${usage}%"
}

mem_usage() {
    mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_avail_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    mem_used_kb=$((mem_total_kb - mem_avail_kb))

    mem_total_gb=$(awk "BEGIN {printf \"%.1f\", $mem_total_kb/1024/1024}")
    mem_used_gb=$(awk "BEGIN {printf \"%.1f\", $mem_used_kb/1024/1024}")
    mem_percent=$(( mem_used_kb * 100 / mem_total_kb ))

    echo "RAM: ${mem_used_gb}/${mem_total_gb} GiB (${mem_percent}%)"
}

battery_status() {
    # Auto-detect battery folder
    for bat in /sys/class/power_supply/BAT*; do
        [ -d "$bat" ] && battery="$bat" && break
    done

    if [ -n "$battery" ]; then
        cap=$(cat "$battery/capacity")
        stat=$(cat "$battery/status")
        echo "BAT: ${cap}% (${stat})"
    else
        echo "BAT: AC"
    fi
}

volume_status() {
    sink=$(pactl get-default-sink)
    vol=$(pactl get-sink-volume "$sink" | grep -o '[0-9]*%' | head -n1)
    mute=$(pactl get-sink-mute "$sink" | awk '{print $2}')

    if [ "$mute" = "yes" ]; then
        echo "VOL: MUTE"
    else
        echo "VOL: ${vol}"
    fi
}

date_status() {
    date '+%A %d %B %Y, %I:%M'
}

# swaybar JSON protocol
echo '{"version":1}'
echo '['
echo '[],'

while :; do
    cpu=$(cpu_usage)
    mem=$(mem_usage)
    bat=$(battery_status)
    vol=$(volume_status)
    dt=$(date_status)

    echo "[{\"full_text\":\"$cpu\"}, {\"full_text\":\"$mem\"}, {\"full_text\":\"$bat\"}, {\"full_text\":\"$vol\"}, {\"full_text\":\"$dt\"}],"
done
