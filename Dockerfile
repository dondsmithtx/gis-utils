FROM centos
RUN dnf -y install wget curl telnet nodejs npm tree lsof postgresql openssh-server initscripts
RUN ssh-keygen -A
EXPOSE 7654
COPY files/bashrc /etc/bashrc
COPY data_layers /data_layers
RUN chmod 666 /etc/sshd_config
RUN chmod 777 /data_layers
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
