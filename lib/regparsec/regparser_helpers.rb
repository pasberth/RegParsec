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
end