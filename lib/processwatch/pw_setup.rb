#License: (MIT), Copyright (C) 2013 Process Watch Author Phil Chen.

module Processwatch_setup

  def setup
    if File.directory?("/usr/local/processwatch")

    puts "Process Watch Is Already Been Installed In /usr/local/processwatch"

    else

    `mkdir -p /usr/local/processwatch/conf`
    general_restart_contact = "/usr/local/processwatch/conf/general_restart_contact"
    restart_ssh = "/usr/local/processwatch/conf/restart_ssh"
    runaway = "/usr/local/processwatch/conf/runaway"
    processwatch = "/usr/local/processwatch/processwatch.rb"

grc = <<END_OF_MESSAGE
#CONFIGURATION KEY
##$restart_smtp_host = SMTP Server To Send Email From
##$restart_smtp_port = SMTP Server Port To Send Email From
##$restart_from = Name of the Email From Field
##$restart_to = Name of the Email To Field
##$restart_from_email = Email Address the Notification Comes From
##$restart_to_email = Email Address the Notification Goes To
#
$restart_smtp_host = "127.0.0.1"
$restart_smtp_port = "25"
$restart_from = "FromName"
$restart_to = "ToName"
$restart_from_email = "from@email.com"
$restart_to_email = "to@email.com"

END_OF_MESSAGE

rs = <<END_OF_MESSAGE
#CONFIGURATION KEY
##$restart_mail = yes or no send email notifying of dead process
##$restart_start = yes or no start the dead process
##$restart_process = name of process try to be unique, you can find the names of processes by running: ps h -eo cm
##$restart_action = command to start the process try to use full paths for everything
#
$restart_mail = "no"
$restart_start = "no"
$restart_process = '/usr/sbin/sshd'
$restart_action = '/etc/init.d/sshd start'

END_OF_MESSAGE

r = <<END_OF_MESSAGE
#CONFIGURATION KEY
##$runaway_max_time = Maximum CPU Time in Seconds That Defines a Run Away Process
##$runaway_smtp_host = SMTP Server To Send Email From
##$runaway_smtp_port = SMTP Server Port To Send Email From
##$runaway_from = Name of the Email From Field
##$runaway_to = Name of the Email To Field
##$runaway_from_email = Email Address the Notification Comes From
##$runaway_to_email = Email Address the Notification Goes To
##$runaway_mail = yes or no send email notifying the runaway process
##$runaway_kill = yes or no kill the runaway process **NOTE BE CAREFUL THIS WILL KILL THE PROCESS
#
$runaway_max_time = "6000"
$runaway_smtp_host = "127.0.0.1"
$runaway_smtp_port = "25"
$runaway_from = "FromName"
$runaway_to = "ToName"
$runaway_from_email = "from@email.com"
$runaway_to_email = "to@email.com"
$runaway_mail = "no"
$runaway_kill = "no"

END_OF_MESSAGE

pw = <<END_OF_MESSAGE
#!/usr/bin/ruby

require 'processwatch'

  include Processwatch

    restart
    runaway

END_OF_MESSAGE

    output = File.open(general_restart_contact, 'w')
    output.puts grc
    output.close

    output = File.open(restart_ssh, 'w')
    output.puts rs
    output.close

    output = File.open(runaway, 'w')
    output.puts r
    output.close

    output = File.open(processwatch, 'w')
    output.puts pw
    output.close

    puts ""
    puts "Installation of Directory Structure and Configuration Files Successful!"
    puts ""
    puts "Go to /usr/local/processwatch/conf to edit configuration files"
    puts ""
    end
  end
end
