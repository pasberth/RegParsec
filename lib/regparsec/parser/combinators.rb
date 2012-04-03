module RegParsec::Regparsers

  [ [:try, :TryParser],
    [:apply, :ApplyParser],
    [:many, :ManyParser],
    [:many1, :Many1Parser],
    [:between, :BetweenParser],
    [:one_of, :OneOfParser]
  ].each do |method, klass|
    module_eval(<<-DEF)
      def #{method}(*args, &result_hook)
        regparser = ::RegParsec::Regparsers::#{klass}.new.curry!(*args)
        regparser.result_hook!(&result_hook) if result_hook
        regparser
      end
    DEF
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

class BetweenParser < Base
  
  def __regparse__ state, open, close, body
    case result = apply(open, body, close).regparse(state)
    when Result::Success
      Result::Success.new( :return_value => result.return_value[1], :matching_string => result.matching_string )
    when Result::Accepted
      Result::Accepted.new( :return_value => result.return_value[1], :matching_string => result.matching_string )
    else
      result
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