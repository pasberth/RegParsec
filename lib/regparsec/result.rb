require 'regparsec'

class RegParsec::Result
  
  include RegParsec

  def initialize informations={}
    informations.each { |key, val| send(:"#{key}=", val) }
  end

  class Success < Result
    attr_accessor :matching_string
  end

  class Accepted < Result
  end

  class Invalid < Result
  end
end
