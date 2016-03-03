class datadog_agent_windows::windows (
  $baseurl = "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli-${datadog_agent_windows::agentversion}.msi") {
  validate_string($baseurl)

  file { 'c:\datadoginstaller':
    ensure => directory,
    owner  => 'Administrator',
    group  => 'Administrators',
    notify => Exec['getdatadog-installer']
  }

  exec { 'getdatadog-installer':
    command  => "invoke-webrequest $baseurl -outfile c:/datadoginstaller/ddagent-cli-${datadog_agent_windows::agentversion}.msi",
    onlyif   => "if ((test-path c:/datadoginstaller/ddagent-cli-${datadog_agent_windows::agentversion}.msi) -eq \$true) {exit 1}",
    provider => powershell,
    notify   => Package['datadog-agent-windows'],
  }

  package { 'datadog-agent-windows':
    ensure          => "${datadog_agent_windows::agentversion}.0",
    source          => "C:/datadoginstaller/ddagent-cli-${datadog_agent_windows::agentversion}.msi",
    install_options => [{
        'APIKEY' => "${datadog_agent_windows::api_key}",
      }
      ],
  }

  service { 'DatadogAgent':
    ensure  => $::datadog_agent_windows::service_ensure,
    enable  => $::datadog_agent_windows::service_enable,
    require => Package['datadog-agent-windows'],
  }
}