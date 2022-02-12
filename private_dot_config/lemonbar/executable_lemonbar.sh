#!/usr/bin/bash

current_window()
{
	printf '%s' "$(xdotool getwindowfocus getwindowname)"
}

datetime()
{
	printf '%s' "$(date +"%a %Y-%m-%d %T %Z")"
}

myip()
{
	local_ip="$(ip route get 1 | awk -F'src' '{print $2}')"
	local_ip="${local_ip/uid*}"
	printf '%s' "$local_ip"
}

getvolume()
{
	vol=$(pamixer --get-mute)
	if [ "$vol" = "false" ];
	then
		vol=$(pamixer --get-volume)
	else
		vol=0
	fi
	printf	'%s' \
		"%{A4:pamixer -i 1:}" \
		"%{A5:pamixer -d 1:}" \
		"%{A1:pamixer -t:}" \
		" vol:$vol% " \
		"%{A}%{A}%{A}"
}

media_control()
{
	status=$(playerctl status)
	if [ "$status" = "Playing" ];
        then
                status="\uf04c"
        else
                status="\uf04b"
	fi

	printf	'%b' \
	        "%{A:playerctl previous:}" \
		" \uf04a" \
        	"%{A}" \
	        "%{A:playerctl play-pause:}" \
		" $status " \
		"%{A}" \
	        "%{A:playerctl next:}" \
		"\uf04e " \
                "%{A}"
}

cpu_load()
{
	printf '%s' "$(uptime | awk '{print $9}' | sed 's/.$//')"
}

cpu_temp()
{
	temp_dir=/sys/class/hwmon/hwmon2/temp1_input
	deg="$(($(< "$temp_dir") * 100 / 10000))" 
	deg="${deg/${deg: -1}}.${deg: -1}°C"
	printf '%s' "$deg"
}

amdgpu_temp()
{
        temp_dir=/sys/class/hwmon/hwmon4/temp1_input
        deg="$(($(< "$temp_dir") * 100 / 10000))"
        deg="${deg/${deg: -1}}.${deg: -1}°C"
	printf '%s' "$deg"
}

current_playing()
{
	title=$(playerctl metadata title)
	if [ -n "$title" ];  
        then
		printf '%s' "$title"
	fi	
}

print_bar()
{
	printf  '%s' \
                "$(current_window) |" \
                " $(current_playing)" \
                "%{r}" \
                "GPU: $(amdgpu_temp) | CPU: $(cpu_temp) | $(cpu_load) |" \
                "$(getvolume)|$(media_control)| ip:$(myip)| $(datetime)"
}

# Traps SIGUSR to force refresh the bar, with minimum refresh rate of 1/s
# Used to refresh on actions
pid=
trap '[[ $pid ]] && kill "$pid"' SIGUSR1

while true; do
        print_bar
	sleep 1 & pid=$!
	wait $!
done
