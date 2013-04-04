#!/usr/bin/ruby

	dir = File.dirname(__FILE__)
	Dir[File.expand_path("#{dir}/modules/*.rb")]. uniq. each do |file| 
	require file
end
