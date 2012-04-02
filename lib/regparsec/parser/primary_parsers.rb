require 'regparsec/regparsers'

class String
  
  def to_regparser
    ::RegParsec::Regparsers::StringParser.well_defined_parser_get(self)
  end
end

class RegParsec::Regparsers::StringParser < RegParsec::Regparsers::Base
  
  def self.well_defined_parser_get str
    (@_well_defined_parsers ||= {})[str] ||= new.curry!(str)
  end
  
  def format_args expecting, *args
    [expecting, *args]
  end

  def __regparse__ input, expecting
    if input[0, expecting.length] == expecting
      Result::Success.new( :return_value => expecting, :matching_string => expecting )
    elsif expecting[0, input.length] == input
      Result::Accepted.new( :return_value => input, :matching_string => input )
    else
      Result::Invalid.new( :return_value => nil )
    end
  end
end