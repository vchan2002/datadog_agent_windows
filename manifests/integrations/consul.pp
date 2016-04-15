# Class: datadog_agent_windows::integrations::consul
#
# This class will install the necessary configuration for the consul integration
#
# Parameters:
#   $url:
#     The URL for consul
#
# Sample Usage:
#
#   class { 'datadog_agent_windows::integrations::consul' :
#     url  => "http://localhost:8500"
#   }
#
class datadog_agent_windows::integrations::consul(
  $url = 'http://localhost:8500'
) inherits datadog_agent_windows::params {

  file { "${datadog_agent_windows::params::conf_dir}/consul.yaml":
    ensure  => file,
    owner   => $datadog_agent_windows::params::dd_user,
    group   => $datadog_agent_windows::params::dd_group,
    mode    => '0644',
    content => template('datadog_agent_windows/agent-conf.d/consul.yaml.erb'),
    require => Package[$datadog_agent_windows::params::package_name],
    notify  => Service[$datadog_agent_windows::params::service_name]
  }
}
