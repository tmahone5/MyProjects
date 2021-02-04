#!/bin/bash
#==================================================#
#  SCRIPT TO PUSH anisble playTO EC2 INSTANCES ====#
#==================================================#
work() {
    # put your job here 
    cd /root/ansible-playbooks/docker_ubuntu1804
    ansible-playbook playbook.yml
}

echo "Launching background job..."
work &
workPID=$!
RUNNING=true



while true; do
    # If no child process, then exit
    [ $(pgrep -c -P$$) -eq 0 ] && echo "All done" && exit
    HOUR="$(date +'%H')"
    if [ $HOUR -ge 0 -a $HOUR -lt 1 ] ; then
        if [ "$RUNNING" == false ]; then
            echo "Start work..."
            kill -CONT $workPID
            RUNNING=true
            
            
        fi
    else
        if [ "$RUNNING" == true ]; then
            echo "Stop work..."
            kill -TSTP $workPID
            RUNNING=false
        fi
    fi
    sleep 2
done




