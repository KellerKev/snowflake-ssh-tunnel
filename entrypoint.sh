/home/spcstunnel/.keys/create-keypair.sh

cd /home/spcstunnel && wget https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v$VSVERSION/openvscode-server-v$VSVERSION-linux-x64.tar.gz
cd /home/spcstunnel && tar -xzf openvscode-server-v$VSVERSION-linux-x64.tar.gz
cd /home/spcstunnel/openvscode-server-v$VSVERSION-linux-x64/bin && chmod 777 ./openvscode-server && ./openvscode-server   --host 0.0.0.0 --port 3001 --without-connection-token   > /home/spcstunnel/openvscodeoutput.log &
rm /home/spcstunnel/openvscode-server-v$VSVERSION-linux-x64.tar.gz
sleep 5



/usr/bin/proxychains4 ncat -k -4 -l 8080 --proxy-type http &

/scripts/install_run.sh 
source /home/spcstunnel/env && /home/spcstunnel/startme.sh 


rm /home/spcstunnel/env
sudo /usr/sbin/sshd -D
exec $@
