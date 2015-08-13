i#/bin/bash
echo "stop all server ..."
passenger stop -p 4001 
passenger stop -p 4002 
passenger stop -p 4003 
passenger stop -p 4004 
echo "done!"
