#!/bin/bash

WEB=$(curl -v --silent https://bosh.io/d/stemcells/bosh-azure-hyperv-centos-7-go_agent 2>&1 | grep Location | awk '{print $3}' | cut -d '/' -f 5 | cut -d '-' -f 3)
echo $WEB
