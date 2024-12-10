#!/bin/bash

if [[ "$SSHKEY" ==  False ]]; then
                echo "KEY IS FALSE"
else

cd /home/spcstunnel/.keys
ssh-keygen -q -N "" -t rsa -b 4096 -C $ENVNAME -f /home/spcstunnel/.keys/id_rsa




    cp id_rsa /home/spcstunnel
    base64 /home/spcstunnel/id_rsa > id_rsa.b64
    echo "SSH PRIVATEKEY" | cat - id_rsa.b64 
    echo "SSH PRIVATEKEY" | cat - id_rsa.b64 | logger 

mkdir ~/.ssh
touch ~/.ssh/authorized_keys
cat id_rsa.pub >>  ~/.ssh/authorized_keys


rm id_rsa
rm id_rsa.b64
rm id_rsa.pub
fi
