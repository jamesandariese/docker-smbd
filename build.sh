#!/bin/sh

docker build -t jamesandariese/smbd .
docker build -t jamesandariese/smbcrypt -f Dockerfile.smbcrypt .
docker push jamesandariese/smbd
docker push jamesandariese/smbcrypt
