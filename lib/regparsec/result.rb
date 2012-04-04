require 'regparsec'

class RegParsec::Result
  
  include RegParsec
  attr_accessor :return_value

  def initialize informations={}
    informations.each { |key, val| send(:"#{key}=", val) }
    @information_keys = informations.each_key.to_a
  end
  
  def == other
    self.class == other.class and @information_keys.all? do |key|
      send(key) == other.send(key)
    end
  rescue NoMethodError
    false
  end

  # apply("string").regparse("string") # => Success
  class Success < Result
    attr_accessor :matching_string
  end
  
  # apply(/\d+/).regparse("123") # => Valid
  # apply(/\d+/).regparse("123 ") # => Success
  class Valid < Result
    attr_accessor :matching_string
  end

  # apply("string").regparse("str") # => Accepted
  class Accepted < Result
    attr_accessor :matching_string
  end

  # apply("string").regparse("invalid") # => Invalid
  class Invalid < Result
  end
end
