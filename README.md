# Process Watch

License: (MIT) Copyright (C) 2013 Phil Chen.

## DESCRIPTION:

Process Watch monitors processes and workflows in your Linux system for anomalies or situations which when arise trigger predetermined actions you designate.

This is useful for systems issues, automating troubleshooting, provisioning, scaling, and much more.

## CURRENT FEATURES:

  Seeing if a daemon/process is running and if not execute some combination of notify and starting it

  Detecting if a process is a runaway if so execute some combination of notify and killing it

  Email system utilization statistics in the state prior to correcting the runaway process or starting a dead one

## PREREQUISITES:

  Linux, Ruby, RubyGems Cron (Or some other scheduler)

  Tested with:  
  ```bash
  ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-linux]
  ruby 1.9.3p429 (2013-05-15) [x86_64-linux]
  rubygems version 1.8.23
  rubygems version 2.0.3
  ```

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
See example restart configuration file restart_ssh
You can add more restart processes with the naming convention restart_uniqueappname (note prefix restart_)

## USING PROCESSWATCH:

The processwatch executable is /usr/local/processwatch/processwatch.rb you will want to set it on a cron like:

*/5 * * * * /usr/bin/ruby /usr/local/processwatch/processwatch.rb
