FROM centos
RUN dnf -y install unzip wget curl telnet nodejs npm tree lsof postgresql 

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
