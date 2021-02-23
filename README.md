# nessus_agent

#### Table of Contents

1. [Description](#description)
2. [Usage - Examples and general tips on how to use the content in this module](#usage)
3. [Contributions - Guide for contributing to the module](#contributions)

## Description

The ```nessus_agent``` module allows you to install, link and unlink nessus agents across linux and windows.

## Usage

### Tasks

Tasks are cross platform so you only need to specify your targets and the task will work out what needs to be done per supported OS across *nix & windows. Whilst they are cross platform tasks, you can only run the ```nessus_agent::link``` & ```nessus_agent::unlink``` tasks on a mix of targets comprising of disparate oses at the same time.


### Agent Install

**Windows**

```
bolt task run nessus_agent::install -t <targets> installer_path="C:\tmp\NessusAgent-8.2.2-x64.msi"
```

**Linux**

RPM & DEB are both supported

```
bolt task run nessus_agent::install -t <targets> installer_path="/tmp/NessusAgent-8.2.2-es7.x86_64.rpm"
```

### Agent Link

If you're using tenable.io then at the very minimum, you'll only need to pass your linking key and your Nessus agents will pair with your tenable instance however they're a bunch of optional parameters you can take advantage of such agent name, groups, offline install and more.


**Pair with Tenable.io**

```
bolt task run nessus_agent::link -t <targets> key=836e1c023f20601162f908234835c0aa1c61c91a4c750a1f094b4adfc396cdde
```

**Pair with Nessus Manager**

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> host="216.58.198.174" port=8834
```
**Groups**

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> groups="mygroup"
```

**Multiple Groups**

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> groups="mygroup,mygroup2,mygroup3"
```

**Name**

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> name="mynode.nodecorp.com"
```

**Offline Install**

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> offline_install=yes
```

**Proxy host & Port**

There are also additional flags around proxy usage with Tenable such as pass ```proxy_username```, ```proxy_password``` and ```proxy_agent```.

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> host=<myhost> port=<hostport> proxy_host="host.corp.com" proxy_port="8834"
```


### Agent Unlink

```
bolt task run nessus_agent::unlink -t <targets>
```


## Plans

### Upload, Install & Link Agent

All of the parameters found in ```nessus_agent::install``` and ```nessus_agent::link``` tasks are supported in this "complete workflow" plan. This plan will allow you to specify a Nessus agent install package locally on your bolt workstation for upload to your remote targets. Once uploaded, it will then install the Nessus agent using the package provided and link the Tenable agent to tenable.io or Nessus Manager, depending on the flags passed. 

```
bolt plan run nessus_agent::install_link -t <targets> install_file_local="/home/user/NessusAgent-8.2.2-x64.msi" install_file_destination="C:\tmp" installer_path="C:\tmp\NessusAgent-8.2.2-x64.msi" key=<yourkey> groups=<mygroups>
```

### Install and Link only

You can set ```upload=false``` to skip the upload step and only **install** and **link** agents if you've already uploaded the Nessus agent installer to the target node(s) via alternate methods.

```
bolt plan run nessus_agent::install_link -t <targets> installer_path=<pathtoinstaller> key=<yourkey> groups=<mygroups> upload=false
```


## Contributions

If anyone would like to contribute to the module, that would be awesome and very much welcomed.
Repo:        https://github.com/kinners00/nessus_agent

If you're experiencing any bugs, please raise an issue below:
Issues link: https://github.com/kinners00/nessus_agent/issues
