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

media_status() {
    local current_media=""
    local symbol=""
    local artist=""
    local title=""
    local status=""

    if command -v cmus-remote &> /dev/null; then
        cmus_info=$(cmus-remote -Q 2>/dev/null)
        if [ $? -eq 0 ]; then
            status=$(echo "$cmus_info" | grep "^status " | cut -d' ' -f2)
            case "$status" in
                "playing")
                    symbol="▶"
                    ;;
                "paused")
                    symbol="⏸"
                    ;;
                "stopped")
                    # For stopped, show last played if available
                    if [ -n "$last_media" ]; then
                        echo "$last_media"
                        return 0
                    fi
                    return 1
                    ;;
            esac
            
            artist=$(echo "$cmus_info" | grep "^tag artist " | cut -d' ' -f3- | head -c 40)
            title=$(echo "$cmus_info" | grep "^tag title " | cut -d' ' -f3- | head -c 50)
            
            if [ -n "$artist" ] && [ -n "$title" ]; then
                if [ ${#artist} -eq 40 ]; then
                    artist="${artist}..."
                fi
                if [ ${#title} -eq 50 ]; then
                    title="${title}..."
                fi
                current_media="$symbol $artist - $title"
            elif [ -n "$title" ]; then
                if [ ${#title} -eq 50 ]; then
                    title="${title}..."
                fi
                current_media="$symbol $title"
            else
                # Try to get filename if no tags
                file=$(echo "$cmus_info" | grep "^file " | cut -d' ' -f2- | xargs basename | head -c 50)
                if [ -n "$file" ]; then
                    # Remove file extension
                    file=$(echo "$file" | sed 's/\.[^.]*$//')
                    if [ ${#file} -eq 50 ]; then
                        file="${file}..."
                    fi
                    current_media="$symbol $file"
                else
                    current_media="$symbol cmus"
                fi
            fi
            
            # Update last_media when we have active playback
            if [ "$status" = "playing" ] || [ "$status" = "paused" ]; then
                last_media="$current_media"
            fi
            
            echo "$current_media"
            return 0
        fi
    fi

    # Try playerctl for other players
    if command -v playerctl &> /dev/null; then
        status=$(playerctl status 2>/dev/null)
        
        if [ $? -ne 0 ] || [ -z "$status" ]; then
            # No active player, show last played if available
            if [ -n "$last_media" ]; then
                echo "$last_media"
                return 0
            fi
            return 1
        fi

        case "$status" in
            "Playing")
                symbol="▶"
                ;;
            "Paused")
                symbol="⏸"
                ;;
            "Stopped")
                # For stopped, show last played if available
                if [ -n "$last_media" ]; then
                    echo "$last_media"
                    return 0
                fi
                return 1
                ;;
            *)
                symbol="♪"
                ;;
        esac

        # Get track info with longer limits
        artist=$(playerctl metadata artist 2>/dev/null | head -c 40)
        title=$(playerctl metadata title 2>/dev/null | head -c 50)
        
        if [ -n "$artist" ] && [ -n "$title" ]; then
            # Truncate if too long
            if [ ${#artist} -eq 40 ]; then
                artist="${artist}..."
            fi
            if [ ${#title} -eq 50 ]; then
                title="${title}..."
            fi
            current_media="$symbol $artist - $title"
        elif [ -n "$title" ]; then
            if [ ${#title} -eq 50 ]; then
                title="${title}..."
            fi
            current_media="$symbol $title"
        else
            current_media="$symbol $status"
        fi

        # Update last_media when we have active playback
        if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
            last_media="$current_media"
        fi

        echo "$current_media"
        return 0
    fi

    # No media players available, show last played if available
    if [ -n "$last_media" ]; then
        echo "$last_media"
        return 0
    fi
    
    return 1
}

date_status() {
    date '+%A %d %B %Y, %I:%M'
}

# Initialize variable for last played media
last_media=""

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

    # Build the status bar array
    status_items=()
    
    # Check for media (first position if available)
    if media=$(media_status); then
        status_items+=("{\"full_text\":\"$media\"}")
    fi
    
    # Add other status items
    status_items+=("{\"full_text\":\"$cpu\"}")
    status_items+=("{\"full_text\":\"$mem\"}")
    status_items+=("{\"full_text\":\"$bat\"}")
    status_items+=("{\"full_text\":\"$vol\"}")
    status_items+=("{\"full_text\":\"$dt\"}")

    # Join array elements with commas
    IFS=','
    echo "[${status_items[*]}],"
    unset IFS
done
