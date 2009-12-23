require 'lib/sosowa'
require 'yaml'
require 'lib/page_info'
require 'lib/ssdata'
#=begin

sw = Sosowa.new

plist = sw.load true

num = 0
plist.each do |page|
	page.ssdata.each do |ssdata|
		num += 1
	end
end

p "Found #{num} ss"

#p "yamlizing data"
#YAML.dump(sw, File.open("test.yaml", "w"))

#p "yamlized done"

#=end

=begin

sw = YAML.load_file("test.yaml")

p "load done"

p68 = sw.page_list[68]

#ip68.load

p "here have #{p68.ssdata.length} ss"
print "title \t author \t post_date \t update \t value \t point \t rate\n"
p68.ssdata.each do |ssdata|
	print "#{ssdata.title}\t#{ssdata.author}\t#{ssdata.post_date}\t#{ssdata.update}\t#{ssdata.value}\t#{ssdata.point}\t#{ssdata.rate}\n"
end

num = 0

sw.page_list.each do |page|
	page.ssdata.each do |ssdata|
			num += 1
	end
end

p "in total there is #{num} ss'"


ss = p68.ssdata[17]

ss.set_content_from_web

str = ss.get_content
p ss.get_content_text

print ss.get_content_text

=end
