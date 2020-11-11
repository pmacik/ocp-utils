
JENKINS_JOB_BUILDER_CONFIG=$(HOME)/.config/jjb/jenkins_jobs.ini
JENKINS_JOB_SERVER=ocpappsvc

.PHONY: test
test:
	for i in *.yml; do jenkins-jobs --conf $(JENKINS_JOB_BUILDER_CONFIG) -s $(JENKINS_JOB_SERVER) test $$i; done

.PHONY: push
push:
	for i in *.yml; do jenkins-jobs --conf $(JENKINS_JOB_BUILDER_CONFIG) -s $(JENKINS_JOB_SERVER) update $$i; done