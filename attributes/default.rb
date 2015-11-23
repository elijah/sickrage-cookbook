default[:sickrage][:user] = 'sickrage'
default[:sickrage][:group] = 'sickrage'

default[:sickrage][:install_dir] = '/opt/sickrage'
default[:sickrage][:config_dir] = '/etc/sickrage'

default[:sickrage][:git_url] = 'https://github.com/sickrage/sickrage.git'
default[:sickrage][:git_ref] = 'master'

default[:sickrage][:settings] = {
  api_key: 'api_key',
  directory: '/usr/data/downloads',
  ignored_words: '',
  imdb_watchlist: 'http://rss.imdb.com/user/urxxx/watchlist',
  library: [],
  nzbs_api_key: 'nzbz_api_key',
  password: 'encrypted-password',
  port: 5000,
  preferred_words: '',
  sabnzbd_api_key: 'sabnzbd_api_key',
  sabnzbd_url: 'https://localhost:9090',
  ssl_cert: '',
  ssl_key: '',
  themoviedb_api_key: 'themoviedb_api_key',
  transmission_url: 'http://localhost:9091',
  twitter_access_token_key: nil,
  twitter_access_token_secret: nil,
  twitter_username: nil,
  username: 'username'
}

