# Class: datadog_agent_windows::params
#
# This class contains the parameters for the Datadog module
#
# Parameters:
#   $api_key:
#       Your DataDog API Key. Please replace with your key value
#   $dd_url
#       The URL to the DataDog application.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class datadog_agent_windows::params {
  $conf_dir     = 'c:\programdata\Datadog\conf.d'
  $dd_user      = 'Administrator'
  $dd_group     = 'Administrators'
  $package_name = 'datadog-agent-windows'
  $service_name = 'DatadogAgent'

  # case $::operatingsystem {
  #  'Windows' : { $rubydev_package = 'ruby-devel' }
  #  default   : { fail("Class[datadog_agent]: Unsupported operatingsystem: ${::operatingsystem}") }
  #}
}
