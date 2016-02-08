#!/bin/bash

LOGFILE="$HOME/zomboid-control.log"
STEAMCMD_DIR="$HOME/steamcmd"
BASEDIR="$HOME/Steam/steamapps/common/Project\ Zomboid\ Dedicated\ Server/"

say_this()
{
    screen -S zomboid -p 0 -X stuff "$1^M" >> $LOGFILE 2>&1
}

update()
{
	echo -n `date` >> $LOGFILE && echo " Running steamcmd update" >> $LOGFILE
	bash $STEAMCMD_DIR/steamcmd.sh +login anonymous +app_update 380870 validate +quit >> $LOGFILE 2>&1
	wait
}

updateRunning()
{
	echo -n `date` >> $LOGFILE && echo " Quitting Project Zomboid" >> $LOGFILE
	say_this "quit"
	sleep 60

	echo -n `date` >> $LOGFILE && echo " Running steamcmd update" >> $LOGFILE
	bash $STEAMCMD_DIR/steamcmd.sh +login anonymous +app_update 380870 validate +quit >> $LOGFILE 2>&1
	wait

	echo -n `date` >> $LOGFILE && echo " Restarting Project Zomboid" >> $LOGFILE
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
}

start()
{
	echo -n `date` >> $LOGFILE && echo " Starting screen session" >> $LOGFILE
	screen -d -m -S zomboid >> $LOGFILE 2>&1

	echo -n `date` >> $LOGFILE && echo " Starting Project Zomboid" >> $LOGFILE
	say_this "cd $BASEDIR"
	say_this "./start-server.sh"
	sleep 60
}

stop()
{
	echo -n `date` >> $LOGFILE && echo " Stopping Project Zomboid" >> $LOGFILE
	say_this "quit"
	sleep 60

	echo -n `date` >> $LOGFILE && echo " Stopping screen session" >> $LOGFILE
	screen -S zomboid -X quit >> $LOGFILE 2>&1
}

title="Zomboid server control panel"
prompt="Pick an option: "
options=("Start server" "Stop server" "Update stopped server" "Update running server" "Quit")

echo $title
PS3="$prompt"
select opt in "${options[@]}"
do
    case $opt in
        "Start server")
            echo "Starting server..."
            start
            echo "Complete."
            ;;
        "Stop server")
            echo "Stopping server..."
            stop
            echo "Complete."
            ;;
        "Update stopped server")
            echo "Updating server..."
            update
            echo "Complete."
            ;;
        "Update running server")
			echo "Updating server..."
			updateRunning
			echo "Complete."
			;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done