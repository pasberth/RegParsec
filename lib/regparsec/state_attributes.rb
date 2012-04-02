require 'regparsec'

class RegParsec::StateAttributes
  
  def initialize attributes={}
    @attrs = attributes
  end
  
  def refresh!
  end

  def commit!
  end
end