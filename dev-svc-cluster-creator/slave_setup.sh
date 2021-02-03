#!/bin/bash

echo "Customizing slave"

yum $DISABLES install -y jq wget httpd-tools make

pip install -U awscli