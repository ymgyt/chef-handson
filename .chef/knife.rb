current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                ENV['CHEF_USER']
user                     ENV['CHEF_USER']
client_key               "#{current_dir}/#{ENV['CHEF_USER_KEY']}"
validation_client_name   "#{ENV['CHEF_ORG']}-validator"
validation_key           "#{current_dir}/#{ENV['CHEF_ORG_KEY']}"
chef_server_url          "#{ENV['CHEF_SERVER_URL']}/organizations/#{ENV['CHEF_ORG']}"
syntax_check_cache_path  "#{current_dir}/syntaccache"
