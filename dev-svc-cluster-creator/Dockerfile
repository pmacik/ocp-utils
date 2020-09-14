FROM jenkins/jenkins:lts-centos

USER root
RUN yum install -y jq wget httpd-tools python3 python3-pip
RUN python3 -m pip install awscli
USER jenkins

ENTRYPOINT "/sbin/tini" "--" "/usr/local/bin/jenkins.sh"
