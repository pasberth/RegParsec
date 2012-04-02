require 'regparsec'
require 'regparsec/regparsers'

class RegParsec::RegularObject < RegParsec::Regparsers::Base

  def initialize
    @regparsers = []
  end
  
  def concat regparser
    @regparsers << try_convert_into_regparser!(regparser)
  end

  def __regparse__ string
    consumed = ""
    unread = string.clone
    @regparsers.each do |regp|
      result = regp.regparse(unread)
      case result
      when Result::Success
        consumed << result.matching_string
        unread = string.sub(result.matching_string, '')
      when Result::Accespted
        return result
      when Result::Invalid
        return result
      end
    end
    
    Result::Success.new( :return_value => consumed, :matching_string => consumed)
  end
end