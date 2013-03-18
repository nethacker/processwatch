#!/usr/bin/ruby

#License: (MIT), Copyright (C) 2013 Phil Chen.

	dir = File.dirname(__FILE__)
	Dir[File.expand_path("#{dir}/modules/*.rb")]. uniq. each do |file| 
	require file
end
