#License: (MIT), Copyright (C) 2013 Author Phil Chen.
require 'date'

dir = File.dirname(__FILE__)

  load File.expand_path("#{dir}/conf/diagnostic")

    if $diagnostic_status == "on"

      diagnostic_dir = File.dirname(__FILE__)
      diagnostic_date = Date.today.to_s
      diagnostic_date_time = Time.now.to_s
      diagnostic_file_name = diagnostic_date

      diagnostic_file = "#{diagnostic_dir}/events/#{diagnostic_file_name}"

diagnostic_output = <<END_OF_MESSAGE
__________________________________________________________________________
BEGIN EVENT DEBUG OUTPUT BEFORE INCIDENT AT #{diagnostic_date_time}
__________________________________________________________________________

________________
netstat -luntp  |  
________________|

#$diagnostic_netstat_listen

________________
ps -aux         |
________________|

#$diagnostic_ps

________________
netstat -an     |
________________|

#$diagnostic_netstat

________________
top -n -2 -b    | 
________________|

#$diagnostic_top

________________
pstree -a       |
________________| 

#$diagnostic_pstree

________________
df -h           |
________________|

#$diagnostic_df

________________
lsof            |
________________|

#$diagnostic_lsof

____________________________
tail -50 /var/log/messages  |
____________________________|

#$diagnostic_system_log

________________________________
#$diagnostic_custom_name_1      
________________________________

#$diagnostic_custom_1

________________________________
#$diagnostic_custom_name_2      
________________________________

#$diagnostic_custom_2

END_OF_MESSAGE

      output = File.open(diagnostic_file, 'a')
      output.puts diagnostic_output
      output.close

    else

end
