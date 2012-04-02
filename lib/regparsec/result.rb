require 'regparsec'

class RegParsec::Result
  
  include RegParsec
  attr_accessor :return_value

  def initialize informations={}
    informations.each { |key, val| send(:"#{key}=", val) }
    @information_keys = informations.each_key.to_a
  end
  
  def == other
    @information_keys.all? do |key|
      send(key) == other.send(key)
    end
  rescue NoMethodError
    false
  end

  class Success < Result
    attr_accessor :matching_string
  end

  class Accepted < Result
    attr_accessor :matching_string
  end

  class Invalid < Result
  end
end
