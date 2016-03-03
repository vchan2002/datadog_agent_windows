# Class: datadog_agent_windows::integrations::iis
#
# This class will install the necessary configuration for the iis integration
#
# Parameters:
#   $url:
#       The URL for iis status URL handled by mod-status.
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
# include 'datadog_agent_windows::integrations::iis'
#
# OR
#
# class { 'datadog_agent_windows::integrations::iis':
#   url      => 'http://example.com/server-status?auto',
#   username => 'status',
#   password => 'hunter1',
#}
#
class datadog_agent_windows::integrations::iis ($tags = []) inherits datadog_agent_windows::params {
  validate_array($tags)

  file { "${datadog_agent_windows::params::conf_dir}/iis.yaml":
    ensure  => file,
    owner   => Administrator,
    group   => Administrators,
    content => template('datadog_agent_windows/agent-conf.d/iis.yaml.erb'),
    require => Package[$datadog_agent_windows::params::package_name],
    notify  => Service[$datadog_agent_windows::params::service_name]
  }
}
