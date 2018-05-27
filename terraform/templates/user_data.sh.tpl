#!/bin/bash

# log file /var/log/cloud-init-output.log

echo ${hostname} > /etc/hostname
if [[ $? -ne 0 ]]; then
   echo "failed to write /etc/hostname" 1>&2
fi

echo "127.0.0.1 ${hostname}" >> /etc/hosts
if [[ $? -ne 0 ]]; then
  echo "failed to write /etc/hosts" 1>&2
fi

sudo service hostname start
if [[ $? -ne 0 ]]; then
  echo "failed to sudo service hostname start" 1>&2
fi

curl -sSLfO https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/14.04/chef-server-core_12.17.33-1_amd64.deb
sudo dpkg -i chef-server-core_12.17.33-1_amd64.deb
rm chef-server-core_12.17.33-1_amd64.deb

mackerel_apikey=${mackerel_apikey}
if [[ -n ${mackerel_apikey} ]]; then
  wget -q -O - https://mackerel.io/file/script/setup-all-apt.sh | MACKEREL_APIKEY='${mackerel_apikey}' sh
fi
