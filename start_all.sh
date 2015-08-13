#/bin/bash
echo "start all server ..."
passenger start -e production -p 4001 &
passenger start -e production -p 4002 &
passenger start -e production -p 4003 &
passenger start -e production -p 4004 &
echo "done!"
