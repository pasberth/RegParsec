class RegParsec::Regparsers::ApplyParser < RegParsec::Regparsers::Base

  def __regparse__ string, *regparsers
    consumed = ''
    unread = string.clone
    list = []
    regparsers.each do |regp|
      result = regp.regparse(unread)
      case result
      when Result::Success
        consumed << result.matching_string
        list << result.return_value
        unread = string.sub(result.matching_string, '')
      when Result::Accepted
        consumed << result.matching_string
        list << result.return_value
        return Result::Accepted.new( :return_value => list, :matching_string => consumed )
      when Result::Invalid
        return Result::Invalid.new
      end
    end
    
    Result::Success.new( :return_value => list, :matching_string => consumed )
  end
end

module RegParsec::Regparseable
  def apply *regparsers, &proc_as_regparser
    ::RegParsers::Regparsers::ApplyParser.new.curry!(*regparsers, &proc_as_regparser)
  end
end