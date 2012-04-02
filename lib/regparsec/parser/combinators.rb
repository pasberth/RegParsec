class RegParsec::Regparsers::ApplyParser < RegParsec::Regparsers::Base

  def __regparse__ state, *regparsers
    consumed = ''
    list = []
    state.commit!
    regparsers.each do |regp|
      result = regp.regparse(state)
      case result
      when Result::Success
        consumed << result.matching_string
        list << result.return_value
        state.input.sub!(result.matching_string, '')
      when Result::Accepted
        consumed << result.matching_string
        list << result.return_value
        state.backdate!
        return Result::Accepted.new( :return_value => list, :matching_string => consumed )
      when Result::Invalid
        state.backdate!
        return Result::Invalid.new
      end
    end
    state.backdate!
    
    Result::Success.new( :return_value => list, :matching_string => consumed )
  end
end

module RegParsec::Regparseable
  def apply *regparsers, &result_proc
    ::RegParsec::Regparsers::ApplyParser.new.curry!(*regparsers, &result_proc)
  end
end