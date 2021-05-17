FROM centos
RUN dnf -y install wget curl telnet nodejs npm tree lsof postgresql
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
