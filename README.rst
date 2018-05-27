==============
 chef handson
==============


pre requirements
================

- AWS
  - IAM User with Admin permission
  - SSH key pair

- terraform <https://github.com/hashicorp/terraform>


quick start
===========


1. set up aws resource

terraform/variable.tf describes configuration variables. if you create ``terraform/terraform.tfvars`` ,terraform automatically loads them to populate variables.

terraform/terraform.tfvars

.. code-block:: text

   access_key = "your access key id"
   secret_key = "your secret key"
   chef_key_name = "your aws ssh key pair name"

.. code-block:: bash

   cd terrafrom
   terraform init
   terraform apply
   ssh -i <path/to/identify> ubuntu@$(terraform output chef-ip) 


2. install chef

.. code-block:: bash

   curl -O https://packages.chef.io/files/stable/chef-server/12.17.33/ubuntu/14.04/chef-server-core_12.17.33-1_amd64.deb
   sudo dpkg -i chef-server-core_12.17.33-1_amd64.deb


3. configure chef server

.. code-block:: bash

   sudo bash -c "echo 127.0.0.1 $(hostname) >> /etc/hosts"
   sudo chef-server-ctl reconfigure
   sudo chef-server-ctl status                
   
