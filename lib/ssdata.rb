require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'lib/encconverter' if RUBY_VERSION >= '1.9'
require 'lib/encconverter18' if RUBY_VERSION < '1.9'

class SSData
	attr_accessor :link, :title, :author, :post_date, :update, :value, :point, :rate, :id

	def initialize page_url, list=nil
		if list then
			utf_list = list 

			@link = utf_list[0]
			@title = utf_list[1]
			@author = utf_list[2]
			@post_date = utf_list[3]
			@update = utf_list[4]
			@value = utf_list[5]
			@points = utf_list[6]
			@rate = utf_list[7]
		end
		@content = nil
		@page_url = page_url
		@id = @link.scan(/key=(\d+)/)[0][0]
	end

	def set_content content
		@content = content
	end

	def set_content_from_web
		raw_html = open(@link).read
		utf8_html = EncConverter::convert_to_utf8(raw_html)
		html = Nokogiri(utf8_html)
		@content = html.search('div')[1].inner_html(:encoding=>'UTF-8')
	end

	def get_content
		return @content
	end

	def get_content_text
		return @content.gsub(/<br.*?>/, "\n") + "\n"
	end

	
end
