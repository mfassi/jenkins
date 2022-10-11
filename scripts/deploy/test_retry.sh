#!/usr/bin/env bash
set -x
set +e

trap "exit 1" TERM
# Get main script pid so we can kill it from within a function
export MAIN_PID=$$

ssh_command () {
    ssh $1 $2
    exit_code=$?
    if [ ! $exit_code -eq 0 ]
    then
        kill -s TERM $MAIN_PID
    fi
}
                    
if [ $retryCount -gt 1 ]
then
    echo "RETRY NUMBER ${retryCount}"
fi
if [ $i -eq 1 ]
then
    ssh -q sshuser@devcon exit
    RETORNO=$?
    if [ $RETORNO -ne 0 ]
    then
        exit 1
    fi
    if ssh_command "sshuser@devCon" "[ ! -r ./Dockerfile ]"
    then
        echo "Done"
        echo "Command succeeded"
    fi
else
    ssh_command sshuser@devCon "ls /home/jenkins/.ssh"
    echo "### this shouldn't be printed if command fails"
fi