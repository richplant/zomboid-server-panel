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
	echo -ne '           (00%)\r'
	sleep 15
	echo -ne '##         (25%)\r'
	sleep 15
	echo -ne '#####      (50%)\r'
	sleep 15
	echo -ne '#######    (75%)\r'
	sleep 15
	echo -ne '########## (100%)\r'
	echo -ne '\n'
	echo

	echo -n `date` && echo " Running steamcmd update"
	bash $STEAMCMD_DIR/steamcmd.sh +login anonymous +app_update 380870 validate +quit
	wait
	echo

	echo -n `date` && echo " Restarting Project Zomboid"
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
	echo -ne '           (00%)\r'
	sleep 15
	echo -ne '##         (25%)\r'
	sleep 15
	echo -ne '#####      (50%)\r'
	sleep 15
	echo -ne '#######    (75%)\r'
	sleep 15
	echo -ne '########## (100%)\r'
	echo -ne '\n'
	echo
}

start()
{
	echo -n `date` && echo " Starting screen session"
	screen -d -m -S zomboid
	echo

	echo -n `date` && echo " Starting Project Zomboid"
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
	echo -ne '           (00%)\r'
	sleep 15
	echo -ne '##         (25%)\r'
	sleep 15
	echo -ne '#####      (50%)\r'
	sleep 15
	echo -ne '#######    (75%)\r'
	sleep 15
	echo -ne '########## (100%)\r'
	echo -ne '\n'
	echo
}

stop()
{
	echo -n `date` && echo " Stopping Project Zomboid"
	say_this "quit"
	echo -ne '           (00%)\r'
	sleep 15
	echo -ne '##         (25%)\r'
	sleep 15
	echo -ne '#####      (50%)\r'
	sleep 15
	echo -ne '#######    (75%)\r'
	sleep 15
	echo -ne '########## (100%)\r'
	echo -ne '\n'
	echo

	echo -n `date` && echo " Stopping screen session"
	screen -S zomboid -X quit
	echo
}

title="\e[1mZomboid server control panel\e[0m"
prompt="Pick an option: "
options=("Start server" "Stop server" "Update stopped server" "Update running server" "Quit")

echo -e $title 1>&3
if screen -list | grep -q "zomboid"; then
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
            echo "Starting server..." | tee /dev/fd/3
            start | tee /dev/fd/3
            echo "Complete." | tee /dev/fd/3
            ;;
        "Stop server")
            echo "Stopping server..." | tee /dev/fd/3
            stop | tee /dev/fd/3
            echo "Complete." | tee /dev/fd/3
            clear
            ;;
        "Update stopped server")
            echo "Updating server..." | tee /dev/fd/3
            update | tee /dev/fd/3
            echo "Complete." | tee /dev/fd/3
            ;;
        "Update running server")
			echo "Updating server..." | tee /dev/fd/3
			updateRunning | tee /dev/fd/3
			echo "Complete." | tee /dev/fd/3
			;;
        "Quit")
            exit
            ;;
        *) echo invalid option;;
    esac
done 2>&3