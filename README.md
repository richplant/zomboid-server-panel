# zomboid-server-panel
A little bash utility to manage a Project Zomboid dedicated server.

Allows you to start, stop and update either a stopped or running server. Zomboid server process runs in a screen session, so won't end when you close your terminal session.

Prerequisites:

* Project Zomboid dedicated server (update the BASEDIR to point to your installation path)
* Steamcmd (update STEAMCMD_DIR to point to that)
* GNU screen (https://www.gnu.org/software/screen/)

Known issues:

Couldn't track down a good way to wait for the Zomboid process inside the screen session to exit out cleanly, so the script currently just waits 60 seconds every time. Feel free to point out a better way to do this.
