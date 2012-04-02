require 'regparsec'
require 'regparsec/regparsers'

class RegParsec::Regparsers::Base
  
  include RegParsec
  include RegParsec::RegparserHelpers
  include RegParsec::Regparseable

  def __parse__ input, *args
    case result = regparse(input)
    when Result::Success
      result.matching_string
    else
      nil
    end
  end
end