#!/usr/bin/env bash
set -e

function shutdown() {
  echo "shutdowning...."
  # stop service and clean up here
  echo "====> Stopping monad cloud ...."
  cd /apps/cloud && bin/monad-cloud stop
  echo "====> OK"
}
# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "shutdown" HUP INT QUIT KILL TERM

usage(){
  echo "env:"
  echo "CONF_DIR config directory"
  echo "============================="
  echo "CLOUD_PORT cloud bind port,such as 3333,required"
  echo "DATA_DIR cloud data directory"
  echo "LOG_DIR log directory"
  exit 1
}

#add --help
while true; do
	case "$1" in
		-h | --help ) usage; shift;;
		* ) break ;;
	esac
	shift
done

if [ -z $CONF_DIR ]; then
  if [ -z $CLOUD_PORT ]; then
    export CLOUD_PORT=3333
  fi
  if [ -z $DATA_DIR ]; then
    export DATA_DIR=/monad-cloud-data
  elif [ ! -d $DATA_DIR ]; then
    echo "$DATA_DIR doesn't exists or can't be written"
    usage;
  fi
  if [ -z $LOG_DIR ]; then
    export LOG_DIR=/monad-cloud-log
  elif [ ! -d $LOG_DIR ]; then
    echo "$LOG_DIR doesn't exists or can't be written"
    usage;
  fi
else
  # 使用配置文件的定义
  . $CONF_DIR/.cloudrc
  echo "using config dir:$CONF_DIR"
  if [ -z $LOG_DIR ]; then
    LOG_DIR=/monad-cloud-log
  fi
fi

if [ $CONF_DIR ]; then
  echo "CONF_DIR: ${CONF_DIR}"
  echo "JAVA_OPTIONS=\" $JAVA_OPTIONS -Dconfig.dir=${CONF_DIR} \" " > /etc/default/cloud
fi


#start monad application

touch /apps/cloud/out.log
touch ${LOG_DIR}/monad.cloud.log

echo "====> Starting monad  cloud ...."
cd /apps/cloud && bin/monad-cloud start
echo "====> OK"


echo "application running"
$JAVA_HOME/bin/jps

sleep 2
cat /apps/cloud/out.log
tail -F ${LOG_DIR}/monad.cloud.log

shutdown

echo "exited $0"

