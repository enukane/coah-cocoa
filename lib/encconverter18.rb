require 'Kconv'

class EncConverter
	def self.convert_to_utf8 str
		utf8_output = ''
		utf8_output = Kconv.toutf8(str)
		return utf8_output
	end
end			
