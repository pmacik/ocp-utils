
JENKINS_JOB_BUILDER_CONFIG=$(HOME)/.config/jjb/jenkins_jobs.ini
JENKINS_JOB_SERVER=ocpappsvc

JOBS?="*.yaml"

.PHONY: test
test:
	for i in $(JOBS); do PYTHONHTTPSVERIFY=0 jenkins-jobs --conf $(JENKINS_JOB_BUILDER_CONFIG) -s $(JENKINS_JOB_SERVER) test $$i; done

.PHONY: push
push:
	for i in $(JOBS); do PYTHONHTTPSVERIFY=0 jenkins-jobs --conf $(JENKINS_JOB_BUILDER_CONFIG) -s $(JENKINS_JOB_SERVER) update $$i; done