#!/usr/bin/env bash
set -e

function startup() {
  echo "starting ..."
  #create directory
  mkdir -p ${DATA_DIR}/node-db
  mkdir -p ${DATA_DIR}/node-index
  mkdir -p ${DATA_DIR}/sync-db
  # stop service and clean up here
  apps=("cloud" "group" "sync" "node" "api")
  num=${#apps[@]}
  for (( i=0; i < num; i++ )); do
    app=${apps[i]}
    echo "starting ${app} ..."
    touch /apps/${app}/out.log
    touch ${LOG_DIR}/monad.${app}.log
    cd /apps/${app} && bin/monad-${app} start
    sleep 5
    cat /apps/${app}/out.log
  done
  $JAVA_HOME/bin/jps
}

function shutdown() {
  echo "shutdowning...."
  # stop service and clean up here
  apps=("cloud" "group" "sync" "node" "api")
  for (( i=0; i < num; i++ )); do
    app=${apps[i]}
    cd /apps/${app} && bin/monad-${app} stop
  done
}

trap "shutdown" HUP INT QUIT KILL TERM

usage(){
  echo "env:"
  echo "DATA_DIR data directory"
  echo "LOG_DIR log directory"
  exit 1
}

if [ -z $DATA_DIR ]; then
  export DATA_DIR=/monad-data
elif [ ! -d $DATA_DIR ]; then
  echo "$DATA_DIR doesn't exists or can't be written"
  usage;
fi

if [ -z $LOG_DIR ]; then
  export LOG_DIR=/monad-log
elif [ ! -d $LOG_DIR ]; then
  echo "$LOG_DIR doesn't exists or can't be written"
  usage;
fi

#API configuration
export GROUP_API_URL=http://127.0.0.1:9080/group/api
#group
export CLOUD_ADDRESS=127.0.0.1:3333
export API_URL=http://127.0.0.1:9081/api
#node
export GROUP_API_URL=http://127.0.0.1:9080/group/api
export NODE_BIND=0.0.0.0:5555
export NODE_EXPOSE_BIND=127.0.0.1:5555
#sync
export GROUP_API_URL=http://127.0.0.1:9080/group/api
export SYNC_BIND=0.0.0.0:5556
export SYNC_EXPOSE_BIND=127.0.0.1:5556

#start monad application
touch $LOG_DIR/monad.api.log
startup
#echo "[hit enter key to exit] or run 'docker stop <container>'"
#read
tail -F $LOG_DIR/monad.api.log

shutdown
echo "exited $0"

