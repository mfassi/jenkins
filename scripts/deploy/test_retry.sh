#!/usr/bin/env bash

echo "######"
echo "$WORKSPACE"
echo "#######"
set -x
set +e
# test
trap "exit 1" TERM
export MAIN_PID=$$

# Get main script pid so we can kill it from within a function
ssh_command () {
    ssh $1 $2
    exit_code=$?
    if [ ! $exit_code -eq 0 ]
    then
        >&2 echo "Command failed"
        kill -s TERM $MAIN_PID
    fi
}
                    
if [ $1 -gt 1 ]
then
    echo "RETRY NUMBER $1"
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