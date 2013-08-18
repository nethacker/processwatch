#License: (MIT), Copyright (C) 2013 Process Watch Author Phil Chen.

module Processwatch

  def restart

    ps_list = `ps h -eo cmd`
    require 'socket'
    host = Socket.gethostname
    dir = File.dirname("/usr/local/processwatch/conf")
    load File.expand_path("#{dir}/conf/general_restart_contact")

    Dir[File.expand_path("#{dir}/conf/restart_*")]. uniq. each do |file|
      load file

    list = ps_list.split(/\n/)

restart_msgstr = <<END_OF_MESSAGE
From: #$restart_from <#$restart_from_email>
To: #$restart_to <#$restart_to_email>
Subject: Dead Process Detected On #{host}

Process Watch has detected #{$restart_process} has died.

We have started #{$restart_process} again.

#{diagnostic_msgstr}

-Process Watch

END_OF_MESSAGE

dead_process_msgstr = <<END_OF_MESSAGE
From: #$restart_from <#$restart_from_email>
To: #$restart_to <#$restart_to_email>
Subject: Dead Process Detected On #{host}

Process Watch has detected #{$restart_process} has died.

#{diagnostic_msgstr}

-Process Watch

END_OF_MESSAGE

    occurances = list.grep(/.*#$restart_process.*/)
    if occurances.length == 0 && $restart_mail == "yes" && $restart_start == "yes"
      usw =  Usagewatch
diagnostic_msgstr = << END_OF_MESSAGE
- #{usw.uw_diskused} Gigabytes Used
- #{usw.uw_diskused_perc} Perventage of Gigabytes Used
- #{usw.uw_cpuused}% CPU Used
- #{usw.uw_tcpused} TCP Connections Used
- #{usw.uw_udpused} UDP Connections Used
- #{usw.uw_memused}% Active Memory Used
- #{usw.uw_load} Average System Load Of The Past Minute
- #{usw.uw_bandrx} Mbit/s Current Bandwidth Received
- #{usw.uw_bandtx} Mbit/s Current Bandwidth Transmitted
- #{usw.uw_diskioreads}/s Current Disk Reads Completed
- #{usw.uw_diskiowrites}/s Current Disk Writes Completed
- Top Ten Processes By CPU Consumption: #{usw.uw_cputop}
- Top Ten Processes By Memory Consumption: #{usw.uw_memtop}
END_OF_MESSAGE
        system $restart_action
          require 'net/smtp'
          Net::SMTP.start("#$restart_smtp_host", "#$restart_smtp_port") do |smtp|
          smtp.send_message(restart_msgstr, "#$restart_from_email", "#$restart_to_email")
    end
    elsif occurances.length == 0 && $restart_mail == "yes" && $restart_start == "no"
      usw =  Usagewatch
diagnostic_msgstr = << END_OF_MESSAGE
- #{usw.uw_diskused} Gigabytes Used
- #{usw.uw_diskused_perc} Perventage of Gigabytes Used
- #{usw.uw_cpuused}% CPU Used
- #{usw.uw_tcpused} TCP Connections Used
- #{usw.uw_udpused} UDP Connections Used
- #{usw.uw_memused}% Active Memory Used
- #{usw.uw_load} Average System Load Of The Past Minute
- #{usw.uw_bandrx} Mbit/s Current Bandwidth Received
- #{usw.uw_bandtx} Mbit/s Current Bandwidth Transmitted
- #{usw.uw_diskioreads}/s Current Disk Reads Completed
- #{usw.uw_diskiowrites}/s Current Disk Writes Completed
- Top Ten Processes By CPU Consumption: #{usw.uw_cputop}
- Top Ten Processes By Memory Consumption: #{usw.uw_memtop}
END_OF_MESSAGE
      require 'net/smtp'
      Net::SMTP.start("#$restart_smtp_host", "#$restart_smtp_port") do |smtp|
      smtp.send_message(dead_process_msgstr, "#$restart_from_email", "#$restart_to_email")
    end
    elsif occurances.length == 0 && $restart_mail == "no" && $restart_start == "yes"
      system $restart_action
    end
  end
end

  def runaway

    ps_list = `ps h -eo cputime,pcpu,pid,user,cmd`

    dir = File.dirname("/usr/local/processwatch/conf")

    Dir[File.expand_path("#{dir}/conf/runaway")]. uniq. each do |file|
      load file

      list = ps_list.split(/\n/)
      list.each do |p|
      process = p.split
      process[0] =~ /(\d+):(\d+):(\d+)/

      cpu_time = ($1.to_i*3600.to_i + $2.to_i*60.to_i + $3.to_i)
    next if cpu_time.to_i < $runaway_max_time.to_i
    begin

msgstr = <<END_OF_MESSAGE
From: #$runaway_from <#$runaway_from_email>
To: #$runaway_to <#$runaway_to_email>
Subject: Runaway Process Detected

#{process[4]}

END_OF_MESSAGE

        if $runaway_mail == "yes" && $runaway_kill == "yes"
          require 'net/smtp'
          Net::SMTP.start("#$runaway_smtp_host", "#$runaway_smtp_port") do |smtp|
          smtp.send_message(msgstr, "#$runaway_from_email", "#$runaway_to_email")
            system("/bin/kill" + " " + "-9" + " " + "#{process[2]}")
        end
        elsif $runaway_mail == "yes" && $runaway_kill == "no"
          require 'net/smtp'
          Net::SMTP.start("#$runaway_smtp_host", "#$runaway_smtp_port") do |smtp|
          smtp.send_message(msgstr, "#$runaway_from_email", "#$runaway_to_email")
        end
        elsif $runaway_mail == "no" && $runaway_kill == "yes"
          system("/bin/kill" + " " + "-9" + " " + "#{process[2]}")
        else
          exit
        end
        rescue
          puts "Error Killing the process"
        retry
        end
      end
    end
  end
end
