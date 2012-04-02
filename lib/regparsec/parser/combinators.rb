class RegParsec::Regparsers::ApplyParser < RegParsec::Regparsers::Base

  def __regparse__ string, *regparsers
    consumed = ''
    unread = string.clone
    regparsers.each do |regp|
      result = regp.regparse(unread)
      case result
      when Result::Success
        consumed += result.matching_string
        unread = string.sub(result.matching_string, '')
      when Result::Accespted
        return result
      when Result::Invalid
        return result
      end
    end
    
    Result::Success.new( :matching_string => consumed )
  end
end

module RegParsec::Regparseable
  def apply *regparsers, &proc_as_regparser
    ::RegParsers::Regparsers::ApplyParser.new.curry!(*regparsers, &proc_as_regparser)
  end
end