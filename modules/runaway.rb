ps_list = `ps h -eo cputime,pcpu,pid,user,cmd`

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
