require 'regparsec/regparsers'

class String
  
  def to_regparser
    ::RegParsec::Regparsers::StringParser.new.curry!(self)
  end
end

class RegParsec::Regparsers::StringParser < RegParsec::Regparsers::Base
  
  def format_args expecting, *args
    [expecting, *args]
  end

  def __regparse__ input, expecting
    if input[0, expecting.length] == expecting
      Result::Success.new( matching_string: expecting )
    elsif expecting[0, input.length] == input
      Result::Accepted.new( matching_string: input )
    else
      Result::Invalid.new
    end
  end
end

class Proc
  
  def to_regparser
    ::RegParsec::Regparsers::ProcParser.new.curry!(self)
  end
end

class RegParsec::Regparsers::ProcParser < RegParsec::Regparsers::Base
  
  def format_args proc_as_regparser, *args
    [proc_as_regparser, *args] #, *args.map(&:try_convert_into_regparser.in(::RegParsec::RegparserHelpers)))]
  end

  def __regparse__ input, proc_as_regparser #, *regparsers
    instance_exec input, &proc_as_regparser
  end
end
