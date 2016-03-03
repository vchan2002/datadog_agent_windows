#datadog_agent_windows Puppet module

####Table of Contents

1. [Overview](#overview)
2. [Module description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Elasticsearch](#setup)
* [The module manages the following](#the-module-manages-the-following)
* [Requirements](#requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Advanced features - Extra information on advanced usage](#advanced-features)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Support - When you need help with this module](#support)


##Overview

This module manages the instllation and setup of the Puppet Windows Module (http://www.datadog.com)

##Module description

This module came about as there's a need to deploy Datadog and its integrations, specifically for Windows OSes

This, essentially, is based, almost a semi-fork, of the existing puppet module for datadog

https://github.com/DataDog/puppet-datadog-agent

##Setup

##The module manages the following

##Requirements

* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) Puppet library.
* The Powershell (https://forge.puppetlabs.com/puppetlabs/powershell) Puppet Library'

##Usage

###Main Class

####Install a specific version, along with your API key

class { 'puppet-agent-windows':
    agentversion => '5.6.3'
}

###Install integrations for IIS

    include 'datadog_agent_windows::integrations::iis'
