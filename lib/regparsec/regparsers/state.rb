require 'regparsec/regparsers'

module RegParsec::Regparsers

  [ [:lazy, :LazyParser],
    [:update, :UpdateParser],
  ].each do |method, klass|
    module_eval(<<-DEF)
      def #{method}(*args, &block)
        ::RegParsec::Regparsers::#{klass}.new.curry!(*(args<<block))
      end
    DEF
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
#   TypeSpecifier = apply(lazy { |state| one_of(*state.type_specifiers) })
#   TypeSpecifier.parse(input: "int x = 0;", type_specifiers: %w[void char int])
#   # => ["int"]
#   TypeSpecifier.parse(input: "float x = 0;", type_specifiers: %w[void char int])
#   # => nil
#   TypeSpecifier.parse(input: "float x = 0;", type_specifiers: %w[void char int float])
#   # => ["float"]
#
class RegParsec::Regparsers::LazyParser < RegParsec::Regparsers::Base
  
  def format_args proc, *args
    [proc, *args]
  end

  def __regparse__ state, proc
    state.commit!
    regp = try_convert_into_regparser!( proc.call(state) )
    case result = try(regp).regparse( state )
    when Result::Success, Result::Valid
      state.commit!
      result
    else
      state.backdate!
      result
    end
  end
end

class RegParsec::Regparsers::UpdateParser < RegParsec::Regparsers::Base
  
  def format_args proc, *args
    [proc, *args]
  end

  def __regparse__ state, proc
    proc.call(state)
    Result::Success.new(:return_value => nil, :matching_string => '')
  end
end
