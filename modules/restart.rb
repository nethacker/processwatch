#License: (MIT), Copyright (C) 2013 Phil Chen.

ps_list = `ps h -eo cputime,pcpu,pid,user,cmd`

list = ps_list.split(/\n/)
list.each do |p|
	process = p.split

	dir = File.dirname(__FILE__)
	Dir[File.expand_path("#{dir}/conf/*")]. uniq. each do |file|

		load file

		if process[4] !=~ (/.*#{$restart_process}.*/)

       			system $restart_action
		end

	end
end
