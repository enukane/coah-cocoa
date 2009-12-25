require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'lib/ssdata'
require 'lib/sosowa'
require 'lib/encconverter' if RUBY_VERSION >= '1.9'
require 'lib/encconverter18' if RUBY_VERSION < '1.9'

class PageInfo
  attr_reader :ssdata, :page_num

  @url = nil
  @ssdata = nil
  @base_url = nil
  @page_num = nil

  def initialize page_num,url, base_url
    @page_num = page_num
    @url = url
    @base_url = base_url
  end

  def load doc=nil
    @ssdata = Array.new

    doc_html = doc

    unless doc_html then
      raw_content = open(@url).read
      utf8_content = EncConverter::convert_to_utf8(raw_content)
      doc_html = Nokogiri(utf8_content)
    end

    info_list = parse_page(doc_html)

    info_list.each do |info|
      @ssdata << SSData.new(@url, info)	
    end

  rescue => e#when it fails to access server
    p e
  end

  def parse_page page_doc

    info_list = []

    div_contents = page_doc.search("div.contents")[0]

    table_subjects = div_contents.search("table.subjects")[0]
    tables = table_subjects.search("tr")

    #thread?
    tables.each do |table|
      list = divide_table_to_list(table)

      if list then
        info_list << list
      end
    end

    return info_list
  end

  def divide_table_to_list(table)
    data = []
    list = table.children.search("td")

    # when table's header
    if list.empty? then
      return nil
    end

    # when tag table entry
    if list[0]["class"] == "tags" then
      return nil
    end

    ahref = list.search("a")[0]

    link = @base_url + ahref["href"]
    title = ahref.inner_text.strip
    author = list[1].inner_text.strip
    post_date = list[2].inner_text.strip
    update = list[3].inner_text.strip
    value = list[4].inner_text.strip
    points = list[5].inner_text.strip
    rate = list[6].inner_text.strip

    data << link << title << author << post_date << update << value << points << rate

    return data
  end

  alias reload load
end
