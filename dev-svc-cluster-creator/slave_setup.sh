#!/bin/bash

echo "Customizing slave"

yum $DISABLES install -y jq wget httpd-tools

pip install -U awscli