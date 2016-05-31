FROM debian:jessie
MAINTAINER yuya@j96.org

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server
RUN mkdir -p /var/run/sshd
RUN apt-get install -y --no-install-recommends wget ca-certificates
RUN mkdir -p /root/.ssh && \
  wget --output-document /root/.ssh/authorized_keys \
    https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
RUN rm -fv /usr/sbin/policy-rc.d

CMD ["/usr/sbin/sshd", "-D"]
