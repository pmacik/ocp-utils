#!/bin/bash

set -eo pipefail

## Parameters
# OI_VERSION="4.4.0-0.nightly-2020-01-22-045318"
# OCP4_AWS_CLUSTER_NAME_SUFFIX=""
# OCP_RELEASE_DIR="ocp-dev-preview"
# OCP_RELEASE="4.4"
# POST_CLUSTER_INFO_ON_SLACK="true"
## Secrets
# DEV_SVC_INSTALL_CONFIG="/tmp/dev-svc-install-config.yaml"
# AWS_ACCESS_KEY_ID="..."
# AWS_SECRET_ACCESS_KEY="..."
# GIST_API_TOKEN="..."
# SLACK_API_TOKEN="..."

cd $WORKSPACE

wget -O oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/${OCP_RELEASE_DIR}/${OI_VERSION}/openshift-client-linux-${OI_VERSION}.tar.gz
tar -xvf oc.tar.gz
rm -rvf oc.tar.gz

wget -O oi.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/${OCP_RELEASE_DIR}/${OI_VERSION}/openshift-install-linux-${OI_VERSION}.tar.gz
tar -xvf oi.tar.gz
rm -rvf oi.tar.gz

export PATH=$PATH:$WORKSPACE:$WORKSPACE/ocp-utils.git/ocp4-aws

oc version
openshift-install version

export OCP4_AWS_WORKSPACE=$WORKSPACE/ocp4-aws

mkdir -p $OCP4_AWS_WORKSPACE/vault

cp $DEV_SVC_INSTALL_CONFIG $OCP4_AWS_WORKSPACE/vault/dev-svc-install-config.yaml

export OCP4_AWS_CLUSTER_NAME_SUFFIX=${OCP4_AWS_CLUSTER_NAME_SUFFIX:-${OCP_RELEASE}-$(date +%m%d)}

ocp4-aws -n dev-svc
ocp4-aws -u dev-svc

cd $OCP4_AWS_WORKSPACE/cluster
tar -czf $WORKSPACE/cluster-dir.tar.gz *
cd $WORKSPACE

description=$(ocp4-aws -i dev-svc | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')

export GIST_ADD_API="https://api.github.com/gists"'?'"access_token=$GIST_API_TOKEN"

GIST=$(curl -L -XPOST -d "{\"description\":\"$description\",\"public\":false,\"files\":{\"kubeconfig\":{\"content\":\"$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $OCP4_AWS_WORKSPACE/current/auth/kubeconfig)\"}}}" $GIST_ADD_API)

#--output

OUTPUT=$WORKSPACE/cluster-config.txt
ocp4-aws -i dev-svc > $OUTPUT
echo -n "kubeconfig: " >> $OUTPUT
echo $GIST | jq '.files.kubeconfig.raw_url' | tr -d '"' >> $OUTPUT
echo "openshift-install: $OI_VERSION" >> $OUTPUT

SLACK_TEAM="${SLACK_TEAM:-@openshift-app-services}"

SLACK_MESSAGE="$SLACK_TEAM, Today's dev cluster:\n\`\`\`\n$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $OUTPUT)\`\`\`\n"

echo "------"
echo $SLACK_MESSAGE
echo "------"

if [ "$POST_CLUSTER_INFO_ON_SLACK" == "true" ]; then
    curl -XPOST -H "Content-Type: application/json" -H "Authorization: Bearer $SLACK_API_TOKEN" -d "{\"channel\":\"#forum-os-dev-services\",\"link_names\":\"true\",\"as_user\":\"true\",\"text\":\"$SLACK_MESSAGE\"}" 'https://coreos.slack.com/api/chat.postMessage'
fi
