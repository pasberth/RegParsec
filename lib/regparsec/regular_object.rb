require 'regparsec'

class RegParsec::RegularObject < RegParsec::Regparsers::Base

  def initialize
    @regparsers = []
  end
  
  def concat regparser
    @regparsers << try_convert_into_regparser!(regparser)
  end

  def __regparse__ state
    return apply( *@regparsers ).regparse state
  end
end