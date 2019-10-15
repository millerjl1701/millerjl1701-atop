# atop

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-atop.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-atop)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with atop](#setup)
    * [What atop affects](#what-atop-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with atop](#beginning-with-atop)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Credits](#credits)

## Description

This module manages the installation, configuration and state of the system and process monitor services provided by the atop package. 

The best description of what atop does comes directly from the atop web site:

> Atop is an ASCII full-screen performance monitor for Linux that is capable of reporting the activity of all processes (even if processes have finished during the interval), daily logging of system and process activity for long-term analysis, highlighting overloaded system resources by using colors, etc. At regular intervals, it shows system-level activity related to the CPU, memory, swap, disks (including LVM) and network layers, and for every process (and thread) it shows e.g. the CPU utilization, memory growth, disk utilization, priority, username, state, and exit code.

For more detailed information and documentation concerning atop, please see:

* [https://www.atoptool.nl](https://www.atoptool.nl)
* [https://github.com/Atoptool/atop](https://github.com/Atoptool/atop)

## Setup

### What atop affects

The module installs and configures the atop service. Additionally, atop can also use process accounting provided by the kernel. Depending on the operating system, defaults have been put in place to allow for both atop and atopacctd services to run at startup. This includes the installation and configuration of the operating system appropriate package and service for processing accounting. Please see the data directory for how each operating system will be configured.

The atop module optionally allows for inclusion of the epel class for the installation of the atop package. By default, inclusion of epel on RedHat family systems is disabled assuming that it is managed elsewhere in puppet or content management system like Spacewalk.

### Setup Requirements

This module was written for Puppet 5/6 and depends on the following modules:

* puppetlabs/stdlib
* stahnma/epel (if `manage_epel => true`)

### Beginning with atop

`include atop` should be enough to get the atop service up and running with process accounting enabled.

## Usage

All parameters for the atop module are contained in the main `atop` class. In order to see how to provide the parameters via hiera, see the hiera.yaml file and the data directory. 

Some examples of using the module:

### Install and configure atop, process accounting and epel on 'osfamily == RedHat'
```puppet
class { 'atop':
  manage_epel => true,
}
```

### Install and configure atop but no process accounting pieces
```puppet
class { 'atop':
  manage_package                 => true,
  manage_service_atop            => true,
  mamage_service_atopacctd       => false,
  process_accting_package_manage => false,
  process_accting_service_manage => false,
}
```

## Reference

Puppet strings generated documentation is available in the `docs` directory and at [https://millerjl1701.github.io/millerjl1701-atop](https://millerjl1701.github.io/millerjl1701-atop). Also, the puppet strings generated REFERENCE.md file is provided.

## Limitations

For Debian based operating systems, testing via travis of atopacctd is currently disabled as atopacctd does not run in containers correctly. This was discussed in: [https://github.com/Atoptool/atop/issues/11](https://github.com/Atoptool/atop/issues/11)

The atop program supports a large number of configurable options in `/etc/atoprc` and `~/.atoprc` files. This module currently does not support these files.

This module does not currently handle the installation and configuration of the pieces needed for per-process network statistics. Also on the todo list are development of tasks for remotely querying atop performance metrics as well as the use of atopsar.

## Development

This module uses the [Puppet Development Kit](https://puppet.com/docs/pdk/1.x/pdk.html) for developing, validating, and testing the module. In addition to running acceptance tests locally using vagrant/virtualbox, GitHub Travis CI tests are performed according to the .travis.yml file. 

## Credits

The atop system and process monitor is authored and maintained by Gerlof Langeveld [gerlof.langeveld@atoptool.nl](mailto:gerlof.langeveld@atoptool.nl).