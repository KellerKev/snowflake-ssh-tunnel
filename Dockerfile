FROM debian

RUN useradd -ms /bin/bash spcstunnel

RUN echo "spcstunnel:spcstunnel" | chpasswd

ARG MINIFORGE_NAME=Miniforge3
ARG MINIFORGE_VERSION=24.7.1-0
ARG TARGETPLATFORM

ENV CONDA_DIR=/home/spcstunnel/mamba
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}

RUN apt-get update > /dev/null && \
    apt-get install --no-install-recommends --yes \
        wget bzip2 ca-certificates \
        git \
        ssh \
        sudo \
        git-core \
    	iputils-ping \
    	net-tools \
        bash \
    	autossh \
    	ncat \
        zlib1g-dev \
    	sshpass \
        build-essential \
        libssl-dev \
        libreadline-dev \
        proxychains4 \
        libyaml-dev \
        libsqlite3-dev \
        sqlite3 \
        libxml2-dev \
        libxslt1-dev \
        libcurl4-openssl-dev \
        libffi-dev \
    	autossh \
        vim \
        curl \
        unzip \
        zip \
        psmisc \
        screen \
        systemd \
        pkg-config \
        apt-utils \
        > /dev/null && \
    apt-get clean


RUN  echo "spcstunnel ALL = NOPASSWD: /usr/sbin/ip,/usr/sbin/sshd -D,/tools/unset_variables,/usr/bin/sshpass" >> /etc/sudoers

RUN usermod -aG sudo spcstunnel
USER spcstunnel


ADD keys /home/spcstunnel/.keys
ADD csv  /home/spcstunnel/csv
ADD scripts /scripts
ADD tools /tools
ADD samples /home/spcstunnel/samples
COPY restapi_iceberg.py /home/spcstunnel


RUN    wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
 /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean --tarballs --index-cache --packages --yes && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean --force-pkgs-dirs --all --yes && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc 

RUN echo "export set PATH=$PATH:/home/spcstunnel/spark-3.5.3-bin-hadoop3/bin" >> ~/.bashrc 
#RUN echo "export set JAVA_OPTS=-Dhttp.proxySet=true -Dhttp.proxyHost=localhost -Dhttp.proxyPort=8080" >> ~/.bashrc 


USER root
RUN chown spcstunnel /home/spcstunnel/csv -R
RUN    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc

COPY entrypoint.sh /

RUN chown spcstunnel /home/spcstunnel/.keys  -R && \
    chown spcstunnel /entrypoint.sh   && \
    chown spcstunnel /home/spcstunnel/samples  -R && \
    chown spcstunnel /tools  -R && \
    chown spcstunnel /scripts -R

COPY sshd_config /etc/ssh/sshd_config
COPY proxychains4.conf /etc/proxychains4.conf

RUN mkdir /var/run/sshd && \
    chmod 0755 /var/run/sshd

#FOR JUPYTERLAB
EXPOSE 3000

#FOR VSCODE
EXPOSE 3001

#FOR STREAMLIT
EXPOSE 3002

#FOR THE REST API
EXPOSE 3003



USER spcstunnel
WORKDIR /home/spcstunnel

# INSTALL ASDF AND NODEJS OPTIONALLY
RUN git clone https://github.com/excid3/asdf.git ~/.asdf
RUN echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
RUN echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
RUN echo 'legacy_version_file = yes' >> ~/.asdfrc
RUN echo 'export EDITOR="code --wait"' >> ~/.bashrc
RUN exec $SHELL
ENV PATH="${PATH}:/home/spcstunnel/.asdf/bin/"
RUN /home/spcstunnel/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
RUN   /home/spcstunnel/.asdf/bin/asdf install nodejs 22.11.0
RUN   /home/spcstunnel/.asdf/bin/asdf global nodejs 22.11.0
RUN   curl -s "https://get.sdkman.io" | bash




RUN echo 'export http_proxy="http://localhost:8080"' >> /home/spcstunnel/.bashrc

ENTRYPOINT /bin/bash -c "/entrypoint.sh"
