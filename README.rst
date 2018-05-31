==============
 chef handson
==============


pre requirements
================

- AWS

  - IAM User with Admin permission
  - SSH key pair
  - Route 53 zone(domain)

- direnv(optional) <https://github.com/direnv/direnv>
- terraform <https://github.com/hashicorp/terraform>
- chefdk <https://downloads.chef.io/chefdk>


quick start
===========

0. setup ``.envrc``
-------------------


we setup configuration by environment variables.

.. code-block:: bash

   cp .envrc.template .envrc
   # edit .envrc
   direnv allow

1. set up aws resource
----------------------

.. code-block:: bash

   cd terrafrom
   terraform init
   terraform apply
   ssh -i <path/to/identity> ubuntu@<host>


2. configure chef server
------------------------

.. code-block:: bash

   sudo chef-server-ctl reconfigure
   sudo chef-server-ctl status                

                
3. create user and organization
-------------------------------

.. code-block:: bash

   sudo chef-server-ctl user-create ymgyt yuta yamaguchi <your_email> <password> --filename <secret_name>
   sudo chef-server-ctl org-create ygtio ygt.io --association_user ymgyt --filename ygtio-validator.pem

                
4. configure workstation
------------------------

.. code-block::

   # fetch user and org pem files which we created at step 3 to <chef-handson>/.chef/ by scp or like that
   knife ssl fetch
   knife client list


configure node
==============

.. code-block:: bash

   # create role
   knife role create -d postgresql_server
   knife role edit postgresql_server # add postgresql::server to run_list
   knife role show postgresql_server
   knife role list                

   # install cookbooks
   berks vendor cookbooks
   knife cookbook upload --cookbook-path cookbooks --all                

trouble shoot
=============

reconfigure chef server
-----------------------

.. code-block:: bash

   sudo chef-server-ctl cleanse
   sudo chef-server-ctl reconfigure                
                   

references
==========

- DigitalOcean How to Set Up a Chef 12 Configuration on Ubuntu 14.04 <https://www.digitalocean.com/community/tutorials/how-to-set-up-a-chef-12-configuration-management-system-on-ubuntu-14-04-servers>
