module RegParsec::Regparseable

  def try *regparsers, &result_proc
    ::RegParsec::Regparsers::TryParser.new.curry!(*regparsers, &result_proc)
  end

  def apply *regparsers, &result_proc
    ::RegParsec::Regparsers::ApplyParser.new.curry!(*regparsers, &result_proc)
  end

  def one_of *regparsers, &result_proc
    ::RegParsec::Regparsers::OneOfParser.new.curry!(*regparsers, &result_proc)
  end
end

module RegParsec::Regparsers

class TryParser < Base
  
  def __regparse__ state, doing
    state.commit!
    case result = doing.regparse(state)
    when Result::Success
      result
    else
      state.backdate!
      result
    end
  end
end

class ApplyParser < Base

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
    
    Result::Success.new( :return_value => list, :matching_string => consumed )
  end
end

class OneOfParser < Base
  
  def __regparse__ state, *choices
    choices.any? do |a|
      case result = try(a).regparse(state)
      when Result::Success, Result::Accepted then return result
    # when Result::Accepted then true
      else false
      end
    end or Invalid.new
  end
end
end