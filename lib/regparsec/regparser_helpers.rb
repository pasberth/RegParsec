require 'regparsec'

module RegParsec::RegparserHelpers

  extend self

  def try_convert_into_regparser! regobj
    if regobj.respond_to? :to_regparser
      regobj.to_regparser
    else
      raise TypeError, "Can't convert #{regobj.class} into Regparser"
    end
  end
  
  def build_state_attributes state
    case state
    when ::RegParsec::StateAttributes then state
    when String then ::RegParsec::StateAttributes.new :input => state
    when Hash then ::RegParsec::StateAttributes.new state
    end
  end
end