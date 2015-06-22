#!/bin/bash
CURRENT=`pwd`
BASENAME=`basename $CURRENT`

running(){
 if ! screen -list | grep -q "$BASENAME"
 then
  return 0
 else
  return 1
 fi
}

if [ -z $1 ]
then
    echo "Usage : {start|stop|status|screen|restart}"
    exit
fi

if [ -e ./spigot.jar ]
then
        FILE="spigot.jar"
        COMMAND="stop"
else
       echo Pas de serveur ici.
       exit
fi

start_(){
COMMAND="java -Xms256M -Xmx1G -server -Xrs -XX:ThreadPriorityPolicy=42 -XX:+TieredCompilation -XX:TargetSurvivorRatio=90 -XX:SurvivorRatio=8 -XX:MaxTenuringThreshold=15 -XX:+UnlockExperimentalVMOptions -XX:+UseBiasedLocking -XX:UseSSE=3 -XX:+UseCodeCacheFlushing -XX:+UseThreadPriorities   -XX:+UseFastAccessorMethods -XX:+AggressiveOpts -XX:+ReduceSignalUsage -XX:+UseInterpreter -XX:+UseFastEmptyMethods -XX:+UseSharedSpaces -XX:AllocatePrefetchStyle=1 -XX:+AlwaysCompileLoopMethods -XX:SharedReadOnlySize=30m -XX:+UseConcMarkSweepGC -XX:+RewriteFrequentPairs -XX:+OptimizeStringConcat -XX:+CMSCleanOnEnter -XX:+UseSplitVerifier -XX:+UseInlineCaches -jar $FILE nogui"

screen -dmS $BASENAME $COMMAND


}

testloop(){
while true
do
    running
    if [ $? = 0 ]
        then
            echo "Serveur eteind : $_a"
            sleep 1
                                
        else
            echo "Serveur allumer : $_a"
        fi
done

}

stop_(){
    TMP="$COMMAND\rexit\r"
    screen -S $BASENAME -p 0 -X stuff $TMP
}

restart_(){
stop_
echo "Serveur en cour d'arret"

running
while [ $? = 1 ]
do
    echo "Serveur toujours allumer"
    sleep 1
done

start_
echo "Serveur rallumer"
    
    
}

screen_(){
screen -r $BASENAME
}

running
if [ $? = 1 ]
then
    if [ $1 = "stop" ]
    then
        stop_
        echo stopping
    elif [ $1 = "screen" ]
    then
        screen_
    elif [ $1 = "status" ]
    then
        running
        if [ $? = 1 ]
        then
            echo $BASENAME est en marche.
        else
            echo $BASENAME est est arreter.
        fi
    elif [ $1 = "restart" ]
    then
        restart_
    else
        echo "Usage : {start|stop|status|screen|restart}"
    fi
else
    if [ $1 = "start" ]
    then
        start_
    else
        echo "Usage : {start|stop|status|screen|restart}"
    fi
fi