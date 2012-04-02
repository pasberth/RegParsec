require 'regparsec'
require 'stringio'

class RegParsec::Regparser
  include RegParsec
  include RegParsec::Regparseable
  
  def initialize regparser
    @regparser = ::RegParsec::RegparserHelpers.try_convert_into_regparser!(regparser)
  end

  def __regparse__ input
    consumed = ''
    case input
    when String
      input = StringIO.new(input)
    end
    
    return_value = [].tap do |list|
      buf = ""
      while line = input.gets or !buf.empty?
        buf << line if line
        case result = @regparser.regparse(buf)
        when Result::Success then
          buf = buf.sub(result.matching_string, '')
          consumed << result.matching_string
          list << result.return_value
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
