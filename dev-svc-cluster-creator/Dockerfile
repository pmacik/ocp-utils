FROM jenkins/jenkins:lts-centos

USER root
RUN yum install -y jq wget httpd-tools
USER jenkins

ENTRYPOINT "/sbin/tini" "--" "/usr/local/bin/jenkins.sh"
