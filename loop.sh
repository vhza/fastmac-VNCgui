#!/bin/bash
while true
do
  	echo "loop"
        od -A n -t d -N 1 /dev/urandom
        sleep 69
done
