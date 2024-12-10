#!/bin/bash 
/home/spcstunnel/mamba/bin/python -m venv default_py_env
. /home/spcstunnel/default_py_env/bin/activate && pip install uv
cd /home/spcstunnel && git clone https://github.com/KellerKev/duckberg
cd /home/spcstunnel/duckberg && . /home/spcstunnel/default_py_env/bin/activate && uv pip install -e .

mkdir /home/spcstunnel/jupyter_notebooks
chown spcstunnel /home/spcstunnel/jupyter_notebooks
cp /home/spcstunnel/samples/iceberg_minio.ipynb /home/spcstunnel/jupyter_notebooks
cp /home/spcstunnel/samples/pyspark.ipynb /home/spcstunnel/jupyter_notebooks

. /home/spcstunnel/default_py_env/bin/activate &&  uv pip install jupyterlab
. /home/spcstunnel/default_py_env/bin/activate && uv pip install httpx==0.27.2
. /home/spcstunnel/default_py_env/bin/activate && uv pip install fastapi uvicorn

#cd /home/spcstunnel && git clone https://github.com/jupyterlab/jupyterlab.git
#cd /home/spcstunnel/jupyterlab && . /home/spcstunnel/default_py_env/bin/activate && uv pip install -e . &
#cd /home/spcstunnel/jupyterlab && /home/spcstunnel/default_py_env/bin/jlpm run build:core
#cd /home/spcstunnel/jupyterlab && /home/spcstunnel/default_py_env/bin/jupyter lab build

. /home/spcstunnel/default_py_env/bin/activate && uv pip install ipykernel

. /home/spcstunnel/default_py_env/bin/activate && jupyter lab --ip '*' --port 3000 --notebook-dir=/home/spcstunnel/jupyter_notebooks --no-browser --IdentityProvider.token="" &





echo 'source /home/spcstunnel/env
PORT1=$(shuf -i 2000-65000 -n 1)
PORT2=$(shuf -i 2000-65000 -n 1)
PORT3=$(shuf -i 2000-65000 -n 1)
PORT4=$(shuf -i 2000-65000 -n 1)
PORT5=$(shuf -i 2000-65000 -n 1)
echo $PORT3 > /home/spcstunnel/port.txt
echo $PORT3
echo $PORT5 > /home/spcstunnel/outsideport.txt
echo $PORT5
DECODEDKEY="$(source /home/spcstunnel/env && echo $key1 | base64 --decode)"
echo $DECODEDKEY
echo $SSH_USER
#DYNAMIC PORT FORWARD FROM CONTAINER TO DMZ

ssh-agent bash -c "ssh-add <(echo  \"$DECODEDKEY\") && autossh   -M $PORT1 -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -gnNT  -D 1080 -C -N $SSH_USER@$DMZ_IP" &

#OPTIONALLY  PORT FORWARD 3001 (Streamlit) to DMZ
#ssh-agent bash -c "ssh-add <(echo  \"$DECODEDKEY\") &&  autossh   -M $PORT4 -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -gnNT -C -N  -R localhost:$PORT5:localhost:3002   $SSH_USER@$DMZ_IP" &

#OPTIONALLY  PORT FORWARD 22 (SSH) to DMZ
#ssh-agent bash -c "ssh-add <(echo  \"$DECODEDKEY\") &&  autossh   -M $PORT2 -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -gnNT -C -N  -R localhost:$PORT3:localhost:22   $SSH_USER@$DMZ_IP" &' > /home/spcstunnel/tunnel.sh
chmod +x /home/spcstunnel/tunnel.sh
/home/spcstunnel/tunnel.sh &
sleep 5
. /home/spcstunnel/default_py_env/bin/activate && cd /home/spcstunnel/ && uvicorn restapi_iceberg:app --host 0.0.0.0 --port 3003 --reload &

cd /home/spcstunnel && mkdir streamlit_apps
cp /home/spcstunnel/samples/streamlit/main.py /home/spcstunnel/streamlit_apps
cd /home/spcstunnel/ && . /home/spcstunnel/default_py_env/bin/activate && uv pip install streamlit mitosheet numpy
#cd /home/spcstunnel/streamlit_apps && . /home/spcstunnel/default_py_env/bin/activate && streamlit run main.py --server.port 3002 --server.address 0.0.0.0 --server.runOnSave true   enableXsrfProtection=false enableCORS=false &
cd /home/spcstunnel/streamlit_apps && . /home/spcstunnel/default_py_env/bin/activate && streamlit run main.py --server.port 3002 --server.address 0.0.0.0 --server.runOnSave true enableCORS=false &
FILE=/home/spcstunnel/.jdk21.done
        if test -f "$FILE"; then
        echo "$FILE exists."
        else
        . /home/spcstunnel/.sdkman/bin/sdkman-init.sh &&  sdk install java 21.0.3-tem
        #. /home/spcstunnel/.sdkman/bin/sdkman-init.sh &&  sdk install spark
        touch /home/spcstunnel/.jdk21.done
        fi


cd /home/spcstunnel && wget https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz
cd /home/spcstunnel && tar -xvzf spark-3.5.3-bin-hadoop3.tgz
cp /tools/spark-defaults.conf /home/spcstunnel/spark-3.5.3-bin-hadoop3/conf/
cd /home/spcstunnel && rm spark-3.5.3-bin-hadoop3.tgz


. /home/spcstunnel/default_py_env/bin/activate && uv pip install -e /home/spcstunnel/spark-3.5.3-bin-hadoop3/python &