ARG BASE_IMAGE_TAG
ARG OS_TYPE

FROM $OS_TYPE:$BASE_IMAGE_TAG

ENV container docker

# the seds fail when the files are not available - ignore the error code
RUN sed -i -e 's/mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-fasttrack.repo; \
  sed -i -e 's/#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/' /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-fasttrack.repo; \
  sed -i -e 's/scientificlinux.org\/linux\/scientific/scientificlinux.org\/linux\/scientific\/obsolete/' /etc/yum.repos.d/*.repo; \
  yum -y install openssh-server openssh-clients initscripts \
  && yum clean all \
  && chkconfig sshd on \
  && echo "export RUNLEVEL=5" >> /etc/profile

EXPOSE 22

CMD /sbin/init
