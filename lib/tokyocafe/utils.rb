module TokyoCafe
  module Utils
    def self.decode_strings(input)
      case input.class.to_s
      when "String"
        # HTMLEntities.decode_entities(input).toutf8
        input.toutf8
      when "Array"
        input.map! do |n|
          decode_strings(n)
        end
      when "Hash"
        input.each_pair do |key, value|
          input[key] = decode_strings(value)
        end
      else
        input
      end
    end
  end
end
