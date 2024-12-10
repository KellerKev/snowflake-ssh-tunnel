#!/bin/bash

if [ -z "$GITURL" ]; then

        echo "The GITURL is not set."
else
        if [ -z "$GITTOKEN" ]; then

                echo "The GITOKEN is not set."

        else
                export GITURL="$(printf '%s\n' "${GITURL//"https://"/}")"
                export GITURL="$(echo https://$GITTOKEN@$GITURL)"

        fi

        echo "Cloning " $GITPREPARAMS $GITURL $GITPOSTPARAMS
        cd /home/spcstunnel/ && git clone $GITPREPARAMS $GITURL $GITPOSTPARAMS

fi

if [ -z "$ENCODEDRUNSCRIPT" ]; then
  echo "The RUNSCRIPT is not set."
else
  echo "$ENCODEDRUNSCRIPT" | base64 --decode 
  echo "$ENCODEDRUNSCRIPT" | base64 --decode > /home/spcstunnel/startme.sh
  chmod +x /home/spcstunnel/startme.sh
  /home/spcstunnel/mamba/bin/python /scripts/secrets.py
  cat /home/spcstunnel/env
fi

