#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# ZooKeeper
#
# chkconfig: 2345 89 9
# description: zookeeper

source /etc/rc.d/init.d/functions
[ -e {{ home }}/conf/zookeeper-env.sh ] && source {{ home }}/conf/zookeeper-env.sh

SERVER_SCRIPT={{ home }}/bin/zkServer.sh
RETVAL=0
PIDFILE="${ZOOPIDFILE}"
desc="ZooKeeper daemon"

start() {
  echo -n $"Starting $desc (zookeeper): "
  daemon --user zookeeper ${SERVER_SCRIPT} start
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && touch /var/lock/subsys/zookeeper
  return $RETVAL
}

stop() {
  echo -n $"Stopping $desc (zookeeper): "
  daemon --user zookeeper ${SERVER_SCRIPT} stop
  RETVAL=$?
  sleep 5
  echo
  [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/zookeeper $PIDFILE
}

restart() {
  stop
  start
}

checkstatus(){
  status -p $PIDFILE zookeeper
  RETVAL=$?
}

condrestart(){
  [ -e /var/lock/subsys/zookeeper ] && restart || :
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    checkstatus
    ;;
  restart)
    restart
    ;;
  condrestart)
    condrestart
    ;;
  *)
    echo $"Usage: $0 {start|stop|status|restart|condrestart}"
    exit 1
esac

exit $RETVAL
