#!/bin/bash

echo "Customizing slave"

yum $DISABLES install -y jq wget httpd-tools make which

pip install -U awscli yq