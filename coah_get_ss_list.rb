#!/opt/local/bin/ruby1.9
# -*- coding: utf-8 -*-
require 'lib/sosowa'
require 'lib/page_info'
require 'lib/ssdata.rb'

unless ARGV[0] then
  p "No page specified or invalid"
  exit
end

page_num = ARGV[0].to_i

sw = Sosowa.new

sw.load

new_num = sw.page_list.length

# if page_num is same as length,
# it indicates newest page.
# newest page is always at 0 of sw.page_list
if new_num == page_num then
  page_num = 0
end

page = nil
begin
  page = sw.page_list[page_num]
rescue
  # invalid number
  p "Invalid page number specified"	
  exit
end

page.load

if page_num == 0 then
  p "最新作品集 SS一覧"
else
  p "作品集 #{page_num} SS一覧"
end

printf "タイトル\t作者\tID\n"

page.ssdata.each do |ss|
  printf "%# -50.50s\t %# -20.20s %-10.10s\n", ss.title, ss.author, ss.id
end
