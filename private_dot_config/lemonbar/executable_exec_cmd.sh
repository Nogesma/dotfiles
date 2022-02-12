while read line
do
	sh -c "$line"
	pkill -x -USR1 lemonbar.sh
done
