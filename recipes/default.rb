#
# Cookbook Name:: sickrage
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service 'sickrage'

user node[:sickrage][:user] do
  system true
  shell '/bin/bash'
  home node[:sickrage][:install_dir]
end

app_dirs = [
  node[:sickrage][:install_dir],
  node[:sickrage][:config_dir]
]

app_dirs.each do |dir|
  directory dir do
    recursive true
    mode 0755
    owner node[:sickrage][:user]
    group node[:sickrage][:group]
  end
end

apt_repository 'security-ubuntu-multiverse' do
  uri        'http://security.ubuntu.com/ubuntu'
  distribution 'trusty-security'
  components ['multiverse']
  deb_src 'true'
end

%w{ unrar python-cheetah python-pip python-dev libssl-dev git }.each do |package|
	package "#{package}" do
		action :install
	end
end

git node[:sickrage][:install_dir] do
  repository node[:sickrage][:git_url]
  reference node[:sickrage][:git_ref]
  action :checkout
  checkout_branch(node[:sickrage][:git_ref]) unless node[:sickrage][:git_ref] == 'master'
  enable_checkout node[:sickrage][:git_ref] != 'master'
  user node[:sickrage][:user]
  group node[:sickrage][:group]
  notifies :restart, 'service[sickrage]'
end

template ::File.join(node[:sickrage][:config_dir], 'config.ini') do
  source 'config.ini.erb'
  owner node[:sickrage][:user]
  group node[:sickrage][:group]
  variables(
    api_key: node[:sickrage][:settings][:api_key],
    directory: node[:sickrage][:settings][:directory],
    ignored_words: node[:sickrage][:settings][:ignored_words],
    imdb_watchlist: node[:sickrage][:settings][:imdb_watchlist],
    library: node[:sickrage][:settings][:library],
    nzbs_api_key: node[:sickrage][:settings][:nzbs_api_key],
    password: node[:sickrage][:settings][:password],
    port: node[:sickrage][:settings][:port],
    preferred_words: node[:sickrage][:settings][:preferred_words],
    sabnzbd_api_key: node[:sickrage][:settings][:sabnzbd_api_key],
    sabnzbd_url: node[:sickrage][:settings][:sabnzbd_url],
    sabnzbd_ssl: node[:sickrage][:settings][:sabnzbd_ssl],
    ssl_cert: node[:sickrage][:settings][:ssl_cert],
    ssl_key: node[:sickrage][:settings][:ssl_key],
    themoviedb_api_key: node[:sickrage][:settings][:themoviedb_api_key],
    transmission_url: node[:sickrage][:settings][:transmission_url],
    twitter_access_token_key: node[:sickrage][:settings][:twitter_access_token_key],
    twitter_access_token_secret: node[:sickrage][:settings][:twitter_access_token_secret],
    twitter_username: node[:sickrage][:settings][:twitter_username],
    username: node[:sickrage][:settings][:username]
  )
  notifies :restart, 'service[sickrage]'
end

link '/etc/init.d/sickrage' do
  to ::File.join(node[:sickrage][:install_dir], 'runscripts/init.ubuntu')
  notifies :run, 'execute[sickrage rc.d]'
end

template '/etc/default/sickrage' do
  source 'default.erb'
  variables(
    user: node[:sickrage][:user],
    home: node[:sickrage][:install_dir],
    data: node[:sickrage][:config_dir]
  )
  notifies :restart, 'service[sickrage]'
end

execute 'sickrage rc.d' do
  command 'update-rc.d sickrage defaults'
  not_if { 'update-rc.d -n sickrage defaults | grep "already existd"' }
end


