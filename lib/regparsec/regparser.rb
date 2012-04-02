require 'regparsec'

class RegParsec::Regparser
  include RegParsec::RegparserDelegator
  
  def initialize
    @buf = ""
  end
  
  def parse input
    
    case input
    when String
      input = StringIO.new(input)
    end
    
    while c = input.getc
      @buf << c
      result = regular_object.parse @buf
      case result
      when Result::Success
        return result
      when Result::Accespted
      when Result::Invalid
      end
    end
  end
end
