#
# Cookbook Name:: owncloud
# Recipe:: default
#
# Copyright (C) 2012 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "openssl"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set_unless['mysql']['server_debian_password'] = secure_password
node.set_unless['mysql']['server_root_password'] = secure_password
node.set_unless['mysql']['server_repl_password'] = secure_password

include_recipe "mysql::ruby"
include_recipe "mysql::server"
include_recipe "database"



node.set_unless['owncloud']['admin_password'] = secure_password
node.set_unless['owncloud']['db_password'] = secure_password
node.set_unless['owncloud']['db_user'] = "owncloud"
node.set_unless['owncloud']['db_name'] = "owncloud_db"
node.set_unless['owncloud']['root_dir'] = "/var/www/owncloud"
node.set_unless['owncloud']['data_dir'] = "#{node['owncloud']['root_dir']}/data"


directory "/var/www" do
  owner "www-data"
  group "www-data"
end


oc_version  = "5.0.9"
oc_filename ="owncloud-#{oc_version}.tar.bz2"
oc_url      = "http://download.owncloud.org/community/#{oc_filename}"


execute "download owncloud to www folder" do
  command "wget #{oc_url} -O #{oc_filename}"
  cwd '/var/www'
  returns 0
  action :run
end

execute "untar owncloud installation" do 
  command "tar -xjf #{oc_filename}"
  cwd '/var/www'
  returns 0
  action :run
end

execute "chown www-data:www-data on /var/www/owncloud" do
  command "chown -R www-data:www-data ./owncloud"
  cwd "/var/www"
  returns 0
  action :run
end

mysql_connection_info = {:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']}

database node["owncloud"]["db_name"] do
  connection mysql_connection_info
  provider Chef::Provider::Database::Mysql
  action :create
end


database_user node['owncloud']['db_user'] do
  connection mysql_connection_info
  provider Chef::Provider::Database::MysqlUser
  password node["owncloud"]["db_password"]
  action :create
end

database_user node["owncloud"]["db_user"] do
  connection mysql_connection_info
  provider Chef::Provider::Database::MysqlUser
  database_name node["owncloud"]["db_name"]
  privileges [:all] 
  action :grant
end


template "/var/www/owncloud/config/autoconfig.php" do
  source "autoconfig.php.erb"
  owner "www-data"
  group "www-data"
  mode "0644"
end

template "/etc/nginx/sites-available/owncloud.local" do
  source "owncloud.local"
  owner "root"
  group "root"
  mode "0664"
end

execute "enable owncloud site" do 
  command "nxensite owncloud.local"
  returns 0
  action :run
  notifies :reload, "service[nginx]"
end

hostsfile_entry '127.0.0.1' do
  hostname  'localhost'
  aliases   ['owncloud.local']
  comment   'generated from chef'
  action    :append
end

#for some reason the php5-fpm doesn't have the expected settings, restarting solves the problem...
execute "restart php5-fpm" do
  command "service php5-fpm restart"
  returns 0
  action :run
end
