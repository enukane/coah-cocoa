#!/opt/local/bin/ruby1.9
# -*- coding: utf-8 -*-
require 'lib/sosowa'
require 'lib/page_info'
require 'lib/ssdata'

unless ARGV[0] then
	p "no page or invalid number specified #{ARGV[0]}"
	exit
end

page_num = ARGV[0]

unless ARGV[1] then
	p "no ss specified #{ARGV[1]}"
	exit
end

ss_id = ARGV[1]

sw = Sosowa.new
sw.load
max_page = sw.page_list.length

if page_num.to_i== max_page then
	page_num = 0
end

begin
	page = sw.page_list[page_num.to_i]
rescue
	#invalid number
	p "invalid page number specified: #{page_num}"
	exit
end

page.reload

ssdata = nil

page.ssdata.each do |ss|
	if ss.id == ss_id then
		ssdata = ss
		break
	end
end

unless ssdata then
	p "invalid ss id specified: not found"
	exit
end

printf "タイトル: \t\"%s\"\n", ssdata.title
printf "作者: \t\t%s\n", ssdata.author
printf "投稿日時: \t%s\n", ssdata.post_date
printf "更新日時: \t%s\n", ssdata.update
printf "\n"
ssdata.set_content_from_web
print ssdata.get_content_text

