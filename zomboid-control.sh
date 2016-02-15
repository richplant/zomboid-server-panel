#!/bin/bash

LOGFILE="$HOME/zomboid-control.log"
STEAMCMD_DIR="$HOME/steamcmd"
BASEDIR="$HOME/Steam/steamapps/common/Project\ Zomboid\ Dedicated\ Server/"

exec 3>&1 1>>$LOGFILE 2>&1

say_this()
{
    screen -S zomboid -p 0 -X stuff "$1^M"
}

update()
{
	echo -n `date` && echo " Running steamcmd update"
	bash $STEAMCMD_DIR/steamcmd.sh +login anonymous +app_update 380870 validate +quit
	wait
	echo
}

updateRunning()
{
	echo -n `date` && echo " Quitting Project Zomboid"
	say_this "quit"
	while true
	do
		tail -1 screenlog.0 | grep -q "Project Zomboid Dedicated Server"
		if [ $? = 0 ]
		then
			break
		else
			sleep 1
		fi
	done
	echo

	echo -n `date` && echo " Running steamcmd update"
	bash $STEAMCMD_DIR/steamcmd.sh +login anonymous +app_update 380870 validate +quit
	wait
	echo

	echo -n `date` && echo " Restarting Project Zomboid"
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
	while true
	do
		tail -1 screenlog.0 | grep -q "Zomboid Server is VAC Secure"
		if [ $? = 0 ]
		then
			break
		else
			sleep 1
		fi
	done
	echo
}

start()
{
	echo -n `date` && echo " Starting screen session"
	rm screenlog.*
	screen -L -d -m -S zomboid
	echo

	echo -n `date` && echo " Starting Project Zomboid"
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
	while true
	do
		tail -1 screenlog.0 | grep -q "Zomboid Server is VAC Secure"
		if [ $? = 0 ]
		then
			break
		else
			sleep 1
		fi
	done
	echo
}

stop()
{
	echo -n `date` && echo " Stopping Project Zomboid"
	say_this "quit"
	while true
	do
		tail -1 screenlog.0 | grep -q "Project Zomboid Dedicated Server"
		if [ $? = 0 ]
		then
			break
		else
			sleep 1
		fi
	done
	rm screenlog.*
	echo

	echo -n `date` && echo " Stopping screen session"
	screen -S zomboid -X quit
	echo
}

status()
{
	if screen -list | grep -q "zomboid"; then
		return 0
	else
		return 1
	fi
}

title="\e[1mZomboid server control panel\e[0m"
prompt="Pick an option: "
options=("Start server" "Stop server" "Restart server" "Update server" "Quit")

echo -e $title 1>&3
if status; then
	echo -e "Screen session is \e[32mrunning\e[0m." 1>&3
else
	echo -e "Screen session is \e[31mnot running\e[0m." 1>&3
fi
echo 1>&3

PS3="$prompt"
select opt in "${options[@]}"
do
    case $opt in
        "Start server")
			if status; then
	        	echo "Server is already running."
	        else
	        	echo "Starting server..." | tee /dev/fd/3
	            start | tee /dev/fd/3
	            echo "Complete." | tee /dev/fd/3
	        fi
	        ;;
        "Stop server")
			if status; then
	            echo "Stopping server..." | tee /dev/fd/3
	            stop | tee /dev/fd/3
	            echo "Complete." | tee /dev/fd/3
	        else
	        	echo "Server is already stopped."
	        fi
	        ;;
        "Restart server")
			if status; then
	            echo "Restarting server..." | tee /dev/fd/3
	            stop | tee /dev/fd/3
	            start | tee /dev/fd/3
	            echo "Complete." | tee /dev/fd/3
	        else
	        	echo "Server is not running."
	        fi
	        ;;
        "Update server")
			if status; then
	            echo "Updating server..." | tee /dev/fd/3
	            updateRunning | tee /dev/fd/3
	            echo "Complete." | tee /dev/fd/3
	        else
				echo "Updating server..." | tee /dev/fd/3
				update | tee /dev/fd/3
				echo "Complete." | tee /dev/fd/3
			fi
			;;
        "Quit")
            exit
            ;;
        *) echo invalid option;;
    esac
done 2>&3