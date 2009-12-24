require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'lib/page_info'
require 'lib/encconverter' if RUBY_VERSION >= '1.9'
require 'lib/encconverter18' if RUBY_VERSION < '1.9'
require 'lib/threadpool'

$DMSG =false 

class Sosowa
	attr_reader :page_list
	attr_accessor :url

	def initialize base_url=nil
		@base_url = 'http://coolier.sytes.net:8080/sosowa/ssw_l/'
		if base_url then
			@base_url = url
		end
		@page_list = Array.new
	end

	def load rec=false
		@page_list = Array.new
		
		page_url_list = get_url_list 
=begin
		#not Thread
		page_url_list.each do |url|
			info = PageInfo.new(url,@base_url )
			if rec then
				info.load
			end
			@page_list << info
		end
=end
#=begin
		#Threaded
		pool = ThreadPool.new(4, page_url_list.size)
		0.upto(page_url_list.size-1) do |i|
			pool.dispatch(i,page_url_list) do |i, url|
				p "page #{i} in process" if $DMSG
				info = PageInfo.new(url, @base_url)
				if rec then
					info.load
				end
				@page_list[i] = info
				p "page #{i} done" if $DMSG
			end
		end
		pool.join
#=end
		return @page_list
	end

	def get_url_list
		page_url_list = []
		
		raw_content = open(@base_url).read
		utf8_content = EncConverter::convert_to_utf8(raw_content)
		doc = Nokogiri(utf8_content)
		div_pages = doc.search("ul")

		li_list = div_pages.search("li")

		
		li_list.each do |li|
			begin
				page_url = @base_url + li.search("a")[0]["href"]
				page_num = 	li.search("a")[0].inner_text.strip.to_i
			rescue
				page_url = @base_url
				page_num = 0
			ensure
				page_url_list[page_num] = page_url
			end
		end

		return page_url_list
	end


=begin
>> li_list.each do |li|
?> begin
?> page_num = li.search("a")[0].inner_text.strip.to_i
>> rescue
>> page_num = 0
>> ensure
?> p page_num
>> end
>> end

=end

	def get_page_list num=nil
		if num then
			return @page_list[num]
		end

		return @page_list
	end

	alias reload load
end
