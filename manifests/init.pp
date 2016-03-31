# Class: datadog_agent_windows
#
# This class contains the agent installation mechanism for the Datadog module
#
# Parameters:
#   $dd_url:
#       The host of the Datadog intake server to send agent data to.
#       Defaults to https://app.datadoghq.com.
#   $host:
#       Your hostname to see in Datadog. Defaults with Datadog hostname detection.
#   $api_key:
#       Your DataDog API Key. Please replace with your key value.
#   $collect_ec2_tags
#       Collect AWS EC2 custom tags as agent tags.
#   $collect_instance_metadata
#       The Agent will try to collect instance metadata for EC2 and GCE instances.
#   $tags
#       Optional array of tags.
#   $hiera_tags
#       Boolean to grab tags from hiera to allow merging
#   $facts_to_tags
#       Optional array of facts' names that you can use to define tags following
#       the scheme: "fact_name:fact_value".
#   $puppet_run_reports
#       Will send results from your puppet agent runs back to the datadog service.
#   $puppetmaster_user
#       Will chown the api key used by the report processor to this user.
#   $non_local_traffic
#       Enable you to use the agent as a proxy. Defaults to false.
#       See https://github.com/DataDog/dd-agent/wiki/Proxy-Configuration
#   $dogstreams
#       Optional array of logs to parse and custom parsers to use.
#       See https://github.com/DataDog/dd-agent/blob/ed5e698/datadog.conf.example#L149-L178
#   $log_level
#       Set value of 'log_level' variable. Default is 'info' as in dd-agent.
#       Valid values here are: critical, debug, error, fatal, info, warn and warning.
#   $log_to_syslog
#       Set value of 'log_to_syslog' variable. Default is true -> yes as in dd-agent.
#       Valid values here are: true or false.
#   $use_mount
#       Allow overriding default of tracking disks by device path instead of mountpoint
#       Valid values here are: true or false.
#   $dogstatsd_port
#       Set value of the 'dogstatsd_port' variable. Defaultis 8125.
#   $statsd_forward_host
#       Set the value of the statsd_forward_host varable. Used to forward all
#       statsd metrics to another host.
#   $statsd_forward_port
#       Set the value of the statsd_forward_port varable. Used to forward all
#       statsd metrics to another host.
#   $proxy_host
#       Set value of 'proxy_host' variable. Default is blank.
#   $proxy_port
#       Set value of 'proxy_port' variable. Default is blank.
#   $proxy_user
#       Set value of 'proxy_user' variable. Default is blank.
#   $proxy_password
#       Set value of 'proxy_password' variable. Default is blank.
#   $graphite_listen_port
#       Set graphite listener port
#   $extra_template
#       Optional, append this extra template file at the end of
#       the default datadog.conf template
#   $skip_apt_key_trusting
#       Skip trusting the apt key. Default is false. Useful if you have a
#       separate way of adding keys.
#   $skip_ssl_validation
#       Skip SSL validation.
#   $use_curl_http_client
#       Uses the curl HTTP client for the forwarder
#   $agentversion
#       Windows Agent version
# Actions:
#
# Requires:
#
# Sample Usage:
#
# include datadog_agent_windows
#
# OR
#
# class { 'datadog_agent_windows':
#     api_key   => 'your key',
#     tags      => ['env:production', 'linux'],
#     puppet_run_reports  => false,
#     puppetmaster_user   => puppet,
#}
#
class datadog_agent_windows (
  $dd_url         = 'https://app.datadoghq.com',
  $host           = '',
  $api_key        = 'your_API_key',
  $collect_ec2_tags             = false,
  $collect_instance_metadata    = true,
  $tags           = [],
  $hiera_tags     = false,
  $facts_to_tags  = [],
  $puppet_run_reports           = false,
  $puppetmaster_user            = 'puppet',
  $non_local_traffic            = false,
  $dogstreams     = [],
  $log_level      = 'info',
  $log_to_syslog  = true,
  $service_ensure = 'running',
  $service_enable = true,
  $use_mount      = false,
  $dogstatsd_port = 8125,
  $statsd_forward_host          = '',
  $statsd_forward_port          = 8125,
  $statsd_histogram_percentiles = '0.95',
  $proxy_host     = '',
  $proxy_port     = '',
  $proxy_user     = '',
  $proxy_password = '',
  $graphite_listen_port         = '',
  $extra_template = '',
  $ganglia_host   = '',
  $ganglia_port   = 8651,
  $skip_ssl_validation          = false,
  $skip_apt_key_trusting        = false,
  $use_curl_http_client         = false,
  $agentversion   = '5.6.3') inherits datadog_agent_windows::params {
  validate_string($dd_url)
  validate_string($host)
  validate_string($api_key)
  validate_array($tags)
  validate_bool($hiera_tags)
  validate_array($dogstreams)
  validate_array($facts_to_tags)
  validate_bool($puppet_run_reports)
  validate_string($puppetmaster_user)
  validate_bool($non_local_traffic)
  validate_bool($log_to_syslog)
  validate_string($log_level)
  validate_integer($dogstatsd_port)
  validate_string($statsd_histogram_percentiles)
  validate_string($proxy_host)
  validate_string($proxy_port)
  validate_string($proxy_user)
  validate_string($proxy_password)
  validate_string($graphite_listen_port)
  validate_string($extra_template)
  validate_string($ganglia_host)
  validate_integer($ganglia_port)
  validate_bool($skip_ssl_validation)
  validate_bool($skip_apt_key_trusting)
  validate_bool($use_curl_http_client)
  validate_string($agentversion)

  if $hiera_tags {
    $local_tags = hiera_array('datadog_agent_windows::tags')
  } else {
    $local_tags = $tags
  }

  include datadog_agent_windows::params

  case upcase($log_level) {
    'CRITICAL' : { $_loglevel = 'CRITICAL' }
    'DEBUG'    : { $_loglevel = 'DEBUG' }
    'ERROR'    : { $_loglevel = 'ERROR' }
    'FATAL'    : { $_loglevel = 'FATAL' }
    'INFO'     : { $_loglevel = 'INFO' }
    'WARN'     : { $_loglevel = 'WARN' }
    'WARNING'  : { $_loglevel = 'WARNING' }
    default    : { $_loglevel = 'INFO' }
  }

  case $::operatingsystem {
    'windows' : { include datadog_agent_windows::windows }
    default   : { fail("Class[datadog_agent_windows]: Unsupported operatingsystem: ${::operatingsystem}") }
  }

  if ($extra_template != '') {
    $agent_conf_content = template('datadog_agent_windows/datadog.conf.erb', $extra_template)
  } else {
    $agent_conf_content = template('datadog_agent_windows/datadog.conf.erb')
  }

  file { 'c:\programdata\Datadog\datadog.conf':
    ensure  => file,
    content => $agent_conf_content,
    owner   => 'Administrator',
    group   => 'Administrators',
    require => Package[$datadog_agent_windows::params::package_name],
    notify  => Service[$datadog_agent_windows::params::service_name],
  }

}
