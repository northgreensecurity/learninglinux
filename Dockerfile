FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "AllowUsers root" >> /etc/ssh/sshd_config && \
    service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
