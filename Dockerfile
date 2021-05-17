FROM centos
RUN dnf -y install wget curl telnet nodejs npm tree lsof postgresql openssh-server initscripts
RUN ssh-keygen -A
EXPOSE 7654
COPY files/bashrc /etc/bashrc
RUN chmod 666 /etc/ssh/sshd_config

RUN adduser -m -d /data_layers gis
COPY data_layers /data_layers
RUN chown -R gis /data_layers
COPY files/shadow /etc/shadow
#USER gis
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
