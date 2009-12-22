#!/opt/local/bin/ruby1.9
# -*- coding: utf-8 -*-
require 'lib/sosowa.rb'

sw = Sosowa.new
sw.load
length = sw.page_list.length

puts "東方創想話 作品集一覧"
puts "最新先品集 #{length}" 
(length -1).downto(1) do |num|
				puts "作品集 #{num}"
end


