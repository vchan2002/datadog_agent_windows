# Class: datadog_agent_windows::integrations::windows_service
#
# This class will install the necessary configuration for the sqlserver integration
#
# Parameters:
#   $url:
#       The URL for sqlserver status URL handled by mod-status.
#       Defaults to http://localhost/server-status?auto
#   $username:
#   $password:
#       If your service uses basic authentication, you can optionally
#       specify a username and password that will be used in the check.
#       Optional.
#   $tags
#       Optional array of tags
#
# Sample Usage:
#
# include 'datadog_agent_windows::integrations::sqlserver'
#
# OR
#
# class { 'datadog_agent_windows::integrations::sqlserver':
#   url      => 'LOCALHOST,1433',
#   username => 'status',
#   password => 'hunter1',
#}
#
class datadog_agent_windows::integrations::windows_service ($services = []) inherits datadog_agent_windows::params {
  validate_array($services)

  file { "${datadog_agent_windows::params::conf_dir}/windows_service.yaml":
    ensure  => file,
    owner   => Administrator,
    group   => Administrators,
    content => template('datadog_agent_windows/agent-conf.d/windows_service.yaml.erb'),
    require => Package[$datadog_agent_windows::params::package_name],
    notify  => Service[$datadog_agent_windows::params::service_name]
  }
}
