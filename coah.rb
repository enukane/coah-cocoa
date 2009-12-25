#!/opt/local/bin/ruby1.9
# -*- coding: utf-8 -*-
require 'lib/sosowa'
require 'lib/page_info'
require 'lib/ssdata'

# command should as below
## ./coah.rb page
## ./coah.rb list <page_num>
## ./coah.rb ss <page_num> <ss_id>

$sw = nil
$max_page_num = 0

def init
  $sw = Sosowa.new
  $sw.load
  $max_page_num = $sw.page_list.length
end

def init_page()
  init()

  puts "ERRRO: no page specified" unless ARGV[1]

  page_num = ARGV[1].to_i

  page_num = 0 if $max_page_num == page_num

  page = nil
  begin
    page = $sw.page_list[page_num]
  rescue
    # invalid page number
    puts "ERROR: Invalid page number, or e.t.c"
    exit
  end

  page.load

  return page
end

def eval_page()
  init()

  puts "東方創想話 作品集一覧"
  puts "最新先品集 #{$max_page_num}" 
  ($max_page_num -1).downto(1) do |num|
    puts "作品集 #{num}"
  end
end

def eval_list()
  page = init_page()
  
  if page.page_num == 0 then
    p "最新作品集 SS一覧"
  else
    p "作品集 #{page.page_num} SS一覧"
  end

  printf "\n"
  printf "タイトル\t作者\tID\n"

  page.ssdata.each do |ss|
    printf "%# -50.50s\t %# -20.20s %-10.10s\n", ss.title, ss.author, ss.id
  end
end


def eval_ss()
  page = init_page()

  unless ARGV[2] then
    p "ERROR: No ss specified"
  end

  ss_id = ARGV[2]

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
  ssdata.load_content_from_web
  print ssdata.get_text_content
end

def eval_help()
  p "usage: "
  print "\t./coah.rb page\n"
  print "\t\t-> list pages in Sosowa site\n"
  print "\t./coah.rb list <page_num>\n"
  print "\t\t-> list ss in <page_num> page\n"
  print "\t./coah.rb ss <page_num> <ss_id>\n"
  print "\t\t-> show ss specified by <ss_id> in <page_num> page.\n"
end

def eval_error()
  p "Error: Missing operation"
end

case ARGV[0]
when "page"
  eval_page()
when "list"
  eval_list()
when "ss"
  eval_ss()
when "help"
  eval_help()
else
  eval_error()
end
