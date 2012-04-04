require 'regparsec'
require 'stringio'

class RegParsec::Regparser
  include RegParsec
  include RegParsec::Regparseable
  
  def initialize regparser
    @regparser = ::RegParsec::RegparserHelpers.try_convert_into_regparser!(regparser)
  end

  def __regparse__ state
    consumed = ''
    case state.input
    when String
      input = StringIO.new(state.input)
    else
      input = state.input
    end
    
    return_value = [].tap do |list|
      state.input = ""
      state.commit!
      while line = input.gets or !state.input.empty?
        state.input << line if line
        case result = @regparser.regparse(state)
        when Result::Success then
          state.commit!
          consumed << result.matching_string
          list << result.return_value
        when Result::Valid
          next if line
          state.commit!
          consumed << result.matching_string
          list << result.return_value
          break
        when Result::Accepted then line ? next : break
        when Result::Invalid then break
        end
      end
    end
    
    if return_value.empty?
      Result::Invalid.new
    else
      Result::Success.new :return_value => return_value, :matching_string => consumed
    end
  end
end
