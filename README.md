# Processwatch

License: (MIT) Copyright (C) 2013 Phil Chen.

## DESCRIPTION:

Process Watch monitors processes and workflows in your Linux system for anomalies or situations which when arise trigger predetermined actions you designate.

This is useful for systems issues, automating troubleshooting, provisioning, scaling, and much more.

## CURRENT FEATURES:

  Seeing if a daemon/process is running and if not execute some combination of notify and starting it

  Detecting if a process is a runaway if so execute some combination of notify and killing it

## PREREQUISITES:

  Linux, Ruby, Cron (Or some other scheduler)

## INSTALLATION: 

```bash
$ gem install processwatch
```

Create a file setup.rb

```ruby
require 'processwatch'
  include Processwatch_setup
    setup
```

Run the setup.rb

```bash
ruby setup.rb
```

## CONFIGURATION:

Configure the configuration files locate in /usr/local/processwatch/conf/

Note you can have multiple services monitored for restart.
Sample restart configuration file begins with prefix restart_ naming convention looks like restart_uniqueappname

## USING PROCESSWATCH:

The processwatch executable is /usr/local/processwatch/processwatch.rb you will want to set it on a cron like:

*/5 * * * * /usr/bin/ruby /usr/local/processwatch/processwatch.rb
