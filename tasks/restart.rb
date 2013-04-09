#License: (MIT), Copyright (C) 2013 Author Phil Chen.

ps_list = `ps h -eo cmd`

require 'socket'
host = Socket.gethostname

dir = File.dirname(__FILE__)
Dir[File.expand_path("#{dir}/conf/restart_*")]. uniq. each do |file|

	load file

	list = ps_list.split(/\n/)

restart_msgstr = <<END_OF_MESSAGE
From: #$restart_from <#$restart_from_email>
To: #$restart_to <#$restart_to_email>
Subject: Dead Process Detected On #{host}

Process Watch has detected #{$restart_process} has died.

We have started #{$restart_process} again.

-Process Watch

END_OF_MESSAGE

dead_process_msgstr = <<END_OF_MESSAGE
From: #$restart_from <#$restart_from_email>
To: #$restart_to <#$restart_to_email>
Subject: Dead Process Detected On #{host}

Process Watch has detected #{$restart_process} has died.

-Process Watch

END_OF_MESSAGE


	occurances = list.grep(/.*#$restart_process.*/)
	if occurances.length == 0 && $restart_mail == "yes" && $restart_start == "yes"

		system $restart_action
		
	 	require 'net/smtp'
		Net::SMTP.start("#$restart_smtp_host", "#$restart_smtp_port") do |smtp|
		smtp.send_message(restart_msgstr, "#$restart_from_email", "#$restart_to_email")
	end

	elsif occurances.length == 0 && $restart_mail == "yes" && $restart_start == "no"

		require 'net/smtp'
		Net::SMTP.start("#$restart_smtp_host", "#$restart_smtp_port") do |smtp|
		smtp.send_message(dead_process_msgstr, "#$restart_from_email", "#$restart_to_email")
	end

	elsif occurances.length == 0 && $restart_mail == "no" && $restart_start == "yes"

		system $restart_action


	else 
	
	exit

	end
end
