require 'regparsec/regparsers'

class String
  
  # Convert a string into a RegParser.
  # see also RegParsec::RegParsers::StringParser
  def to_regparser
    ::RegParsec::Regparsers::StringParser.well_defined_parser_get(self)
  end
end

class Regexp
  
  # Convert a regexp into a RegParser.
  # see also RegParsec::RegParsers::RegexpParser
  def to_regparser
    ::RegParsec::Regparsers::RegexpParser.well_defined_parser_get(self)
  end
end

class Proc
  
  # Convert a proc into a RegParser.
  # see also RegParsec::RegParsers::ProcParser
  def to_regparser
    ::RegParsec::Regparsers::ProcParser.new.curry!(self)
  end
end

class RegParsec::Regparsers::StringParser < RegParsec::Regparsers::Base
  
  def self.well_defined_parser_get str
    (@_well_defined_parsers ||= {})[str] ||= new.curry!(str)
  end
  
  def format_args expecting, *args
    [expecting, *args]
  end

  def __regparse__ state, expecting
    if state.input[0, expecting.length] == expecting
      state.input.sub!(expecting, '')
      Result::Success.new( :return_value => expecting, :matching_string => expecting )
    elsif expecting[0, state.input.length] == state.input
      Result::Accepted.new( :return_value => state.input, :matching_string => state.input )
    else
      Result::Invalid.new( :return_value => nil )
    end
  end
end

class RegParsec::Regparsers::RegexpParser < RegParsec::Regparsers::Base
  
  def self.well_defined_parser_get regexp
    (@_well_defined_parsers ||= {})[regexp] ||= new.curry!(regexp)
  end
  
  def format_args expecting, *args
    [expecting, *args]
  end

  def __regparse__ state, regexp
    case state.input                                       # case "abc;def;"
    when /\A#{regexp}\z/                                   # when /\A(.*?);\z/
      md = $~; md[0] =~ /\A#{regexp}/                      #   "abc;def;" =~ /\A(.*?);/
      if $~[0] != md[0]                                    #   if "abc;" != "abc;def;"
        md = $~
        state.input.sub!(md[0], '')
        Result::Success.new( :return_value => md,
                             :matching_string => md[0] )
      else
        state.input.sub!(md[0], '')
        Result::Valid.new( :return_value => md,
                              :matching_string => md[0] )
      end
    when /\A#{regexp}/
      md = $~
      state.input.sub!(md[0], '')
      Result::Success.new( :return_value => md,
                           :matching_string => md[0] )
    else
      Result::Invalid.new( :return_value => nil )
    end
  end
end

# Lambda that will lazy create a RegParser just in run time.
#
#   Expression = one_of(
#     AssignmentExpression,
#     apply(proc { Expression }, ',', AssignmentExpression)
#   )
#
# only argument is a now state.
#
#   TypeSpecifier = apply(->(state) { one_of(*state.type_specifiers) })
#   TypeSpecifier.parse(input: "int x = 0;", type_specifiers: %w[void char int])
#   # => ["int"]
#   TypeSpecifier.parse(input: "float x = 0;", type_specifiers: %w[void char int])
#   # => nil
#   TypeSpecifier.parse(input: "float x = 0;", type_specifiers: %w[void char int float])
#   # => ["float"]
#
class RegParsec::Regparsers::ProcParser < RegParsec::Regparsers::Base
  
  def format_args proc, *args
    [proc, *args]
  end

  def __regparse__ state, proc
    try_convert_into_regparser!( proc.call(state) ).regparse( state )
  end
end
