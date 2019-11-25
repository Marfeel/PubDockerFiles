FROM node:8.10.0-stretch

RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    groupadd -g 1004 jenkins && \
    useradd -d /home/jenkins -m -r -u 1004 -g jenkins jenkins && \
    mkdir -p /home/jenkins/.ssh/ && chown -R jenkins:jenkins /home/jenkins/.ssh/

USER jenkins

RUN git config --global user.email 'sysops@marfeel.com' && \
    git config --global user.name 'jenkins'

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
