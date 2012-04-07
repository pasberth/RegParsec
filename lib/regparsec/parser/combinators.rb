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
    commit = state.commit!
    case result = doing.regparse(state)
    when Result::Success, Result::Valid
      state.commit!
      result
    else
      state.commit! commit
      result
    end
  end
end

class ApplyParser < Base

  def __regparse__ state, *regparsers
    consumed = ''
    list = []
    valid = false
    regparsers.each do |regp|
      result = regp.regparse(state)
      case result
      when Result::Success, Result::Valid
        consumed << result.matching_string
        list << result.return_value
        valid = result.is_a? Result::Valid
      when Result::Accepted
        consumed << result.matching_string
        list << result.return_value
        return Result::Accepted.new( :return_value => list, :matching_string => consumed )
      when Result::Invalid
        return Result::Invalid.new
      end
    end
    
    valid ?
      Result::Valid.new( :return_value => list , :matching_string => consumed ) :
      Result::Success.new( :return_value => list , :matching_string => consumed )
  end
end

class ManyParser < Base
  
  def __regparse__ state, doing
    consumed = ''
    valid = false
    list = [].tap do |list|
      while result = try(doing).regparse(state)
        case result
        when Result::Success, Result::Valid then 
          consumed << result.matching_string
          list << result.return_value
          valid = result.is_a? Result::Valid
        when Result::Accepted then
          return Result::Valid.new( :return_value => list, :matching_string => consumed )
        when Result::Invalid then
          break
        end
      end
    end

    valid ?
      Result::Valid.new( :return_value => list , :matching_string => consumed ) :
      Result::Success.new( :return_value => list , :matching_string => consumed )
  end
end

class Many1Parser < Base
  
  def __regparse__ state, doing
    case head = try(doing).regparse(state)
    when Result::Invalid then head
    when Result::Accepted then head
    when Result::Success, Result::Valid
      result = many(doing).regparse(state)
      if result.return_value.empty? and head.is_a? Result::Valid or result.is_a? Result::Valid then
        Result::Valid.new( :return_value => [head.return_value, *result.return_value], :matching_string => head.matching_string + result.matching_string )
      elsif result.is_a? Result::Success then
        Result::Success.new( :return_value => [head.return_value, *result.return_value], :matching_string => head.matching_string + result.matching_string )
    # when Result::Accepted
    # when Result::Invalid
      end
    end
  end
end

class BetweenParser < Base
  
  def __regparse__ state, open, close, body
    case result = apply(open, body, close).regparse(state)
    when Result::Success
      Result::Success.new( :return_value => result.return_value[1], :matching_string => result.matching_string )
    when Result::Valid
      Result::Valid.new( :return_value => result.return_value[1], :matching_string => result.matching_string )
    when Result::Accepted
      Result::Accepted.new( :return_value => result.return_value[1], :matching_string => result.matching_string )
    else
      result
    end
  end
end

class OneOfParser < Base
  
  def __regparse__ state, *choices
    accepted = nil
    choices.any? do |a|
      case result = try(a).regparse(state)
      when Result::Success, Result::Valid then return result
      when Result::Accepted then accepted ||= result; false
      else false
      end
    end or accepted or Result::Invalid.new
  end
end
end