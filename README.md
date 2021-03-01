# nessus_agent

#### Table of Contents

1. [Description](#description)
1. [Bolt Newcomers - Quickstart](#bolt-quickstart)
1. [Gotchas/Limitations](#gotchas)
1. [Tasks](#tasks)
    1. [install](#install)
    1. [link](#link)
    1. [unlink](#unlink)
    1. [generatelogs](#generatelogs)
1. [Plans](#plans)
    1. [install_link](#install_link)
    1. [generatelogs](#generatelogsplan)
1. [Contributions - Guide for contributing to the module](#contributions)

# Description

The ```nessus_agent``` module allows you to install, link nessus agents as well as perform other nessus agent tasks such as generating bug reports across linux and windows targets.

# Bolt Quickstart

If you're a bolt aficionado, you can skip this section.

If you've never used bolt before, the easiest way to get started is with a bolt project. Bolt projects allow you to keep/organise your bolt automation in a single space. I've created a skeleton of a bolt project here: https://github.com/kinners00/bolt_sandbox.

1. Download/clone repo above
2. Populate your own target inventory information in the ```inventory.yaml``` file (make sure and remove what you don't need and delete #hashs)
3. Navigate to the ```bolt_sandbox``` directory in your shell
4. Install this module in your project by running ```bolt module add kinners00-nessus_agent```
5. Run ```bolt task show``` and ```bolt plan show``` to find out what tasks and plans are available within this module
6. Running ```bolt <automation_type> show <myautomationitem>``` will give you more detailed info on how to use a given task or plan including required and optional parameters. Try it out by running ```bolt task show nessus_agent::link``` within the bolt_sandbox directory/project. As projects are self contained, this command will only work when your pwd is the ```bolt_sandbox``` directory. 

Ps. There's some learning/sample tasks and a plan included in the ```bolt_sandbox``` that'll help you get started with building your own tasks and plans. You can start by creating tasks and plans in their relevant directories within the ```bolt_sandbox```!

# Gotchas

### Bolt tasks are copied and executed under /tmp 

If you can't execute scripts under that directory, you can pass ```--tmpdir``` flag on your bolt command followed by your chosen directory for example ```--tmpdir /var/tmp```

### Pass 'run as root' parameter 

Depending on your targets user level permissions, you may have to pass ```--run-as root``` on your bolt command or add ```run-as: root``` to your config in your `inventory.yaml` file. 

# Usage

## Tasks

Tasks are cross platform so you only need to specify your targets and the task will work out what needs to be done per supported OS across *nix & windows. Whilst they are cross platform tasks, you can only run the ```nessus_agent::link```, ```nessus_agent::unlink``` & ```nessus_agent::generatelogs``` tasks on a mix of targets comprising of disparate oses at the same time.


## install

```nessus_agent::install```

**Windows**

```
bolt task run nessus_agent::install -t <targets> installer_path="C:\tmp\NessusAgent-8.2.2-x64.msi"
```

**Linux**

RPM & DEB are both supported

```
bolt task run nessus_agent::install -t <targets> installer_path="/tmp/NessusAgent-8.2.2-es7.x86_64.rpm"
```

## link

```nessus_agent::link```

If you're using tenable.io then at the very minimum, you'll only need to pass your linking key and your Nessus agents will pair with your tenable instance however they're a bunch of optional parameters you can take advantage of such agent name, groups, offline install and more.


**Pair with Tenable.io**

```
bolt task run nessus_agent::link -t <targets> key=836e1c023f20601162f908234835c0aa1c61c91a4c750a1f094b4adfc396cdde
```

**Pair with Nessus Manager**

Due to issues with use of the ```$host``` variable on windows, I've named equivalent bolt parameter ```server```, which directly translates to ```--host``` flag.

```
bolt task run nessus_agent::link -t <targets> key=<yourkey> server="216.58.198.174" port=8834
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
bolt task run nessus_agent::link -t <targets> key=<yourkey> server=<myhost> port=<hostport> proxy_host="host.corp.com" proxy_port="8834"
```


## unlink

```nessus_agent::unlink```

```
bolt task run nessus_agent::unlink -t <targets>
```


## generatelogs

```nessus_agent::generatelogs```

```
bolt task run nessus_agent::generatelogs -t <targets>
```

**Full log report**

```
bolt task run nessus_agent::generatelogs -t <targets> level=full
```

**Scrub**

The scrub functionality will sanitise the first two octets of IPV4 addresses.

```
bolt task run nessus_agent::generatelogs -t <targets> scrub=true
```


## Plans

## install_link

```nessus_agent::install_link```

All of the parameters found in ```nessus_agent::install``` and ```nessus_agent::link``` tasks are supported in this "complete workflow" plan. This plan will allow you to specify a Nessus agent install package locally on your bolt workstation for upload to your remote targets. Once uploaded, it will then install the Nessus agent using the package provided and link the Tenable agent to tenable.io or Nessus Manager, depending on the flags passed. 

```
bolt plan run nessus_agent::install_link -t <targets> install_file_local="/home/user/NessusAgent-8.2.2-x64.msi" install_file_destination="C:\tmp" installer_path="C:\tmp\NessusAgent-8.2.2-x64.msi" key=<yourkey> groups=<mygroups>
```

**Skipping upload step**

You can set ```upload=false``` to skip the upload step and only **install** and **link** agents if you've already uploaded the Nessus agent installer to the target node(s) via alternate methods.

```
bolt plan run nessus_agent::install_link -t <targets> upload=false installer_path=<pathtoinstaller> key=<yourkey> groups=<mygroups> 
```

## generatelogs(plan)

```nessus_agent::generatelogs```

When a Nessus agent log tarball is generated on linux, it has root ownership as default. This means that bolt can't download logs directly using SCP. To get around this, the ```nessus_agent::generatelogs``` plan changes the ownership of these logs (to a user you specify) to allow them to be downloaded to your workstation. Once logs are downloaded, they are deleted from the target node.


**Linux**

```
bolt plan run nessus_agent::generatelogs -t rhel file_destination="tenablelogs" user=myuser level=full scrub=true
```

**Windows**

```
bolt plan run nessus_agent::generatelogs -t windows file_destination="tenablelogs" level=full scrub=true
```


# Contributions

If anyone would like to contribute to the module, that would be awesome and very much welcomed.
Repo: https://github.com/kinners00/nessus_agent

If you're experiencing any bugs, please raise an issue below.
Issues link: https://github.com/kinners00/nessus_agent/issues
