
class EncConverter
	def self.convert_to_utf8 str
		ec = Encoding::Converter.new(str.encoding.to_s, "UTF-8")

		utf8_output = ''

		begin
			ret = ec.primitive_convert(str, utf8_output)
			case ret
			when :invalid_byte_sequence
				ec.insert_output(ec.primitive_errinfo[3].dump[1..-2])
				redo
			when :undefined_conversion
				c = ec.primitive_errinfo[3].dup.force_encoding(ec.primitive_errinfo[1])
				ec.insert_output('\x{%X:%s}' % [c.ord, c.encoding])
				redo
			when :incomplete_input
				ec.insert_output(ec.primitive_errinfo[3].dump[1..-2])
			when :finished
			end
			break
		end while nil

		return utf8_output
	end
end
