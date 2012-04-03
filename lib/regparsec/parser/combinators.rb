module RegParsec::Regparseable

  def try *regparsers, &result_proc
    ::RegParsec::Regparsers::TryParser.new.curry!(*regparsers, &result_proc)
  end
  
  def apply *regparsers, &result_proc
    ::RegParsec::Regparsers::ApplyParser.new.curry!(*regparsers, &result_proc)
  end

  def many *regparsers, &result_proc
    ::RegParsec::Regparsers::ManyParser.new.curry!(*regparsers, &result_proc)
  end
  
  def many1 *regparsers, &result_proc
    ::RegParsec::Regparsers::Many1Parser.new.curry!(*regparsers, &result_proc)
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

class ManyParser < Base
  
  def __regparse__ state, doing
    consumed = ''
    list = [].tap do |list|
      while result = try(doing).regparse(state)
        case result
        when Result::Success then 
          consumed << result.matching_string
          list << result.return_value
        when Result::Accepted then
          consumed << result.matching_string
          list << result.return_value
          return Result::Accepted.new( :return_value => list, :matching_string => consumed )
        when Result::Invalid then
          break
        end
      end
    end

    Result::Success.new( :return_value => list , :matching_string => consumed )
  end
end

class Many1Parser < Base
  
  def __regparse__ state, doing
    case result = many(doing).regparse(state)
    when Result::Success
      if result.return_value.empty?
        Result::Invalid.new
      else
        result
      end
    when Result::Accepted then result
    else result
    end
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