require 'regparsec/regparsers'

module RegParsec::Regparsers

  def update_state *regparsers, &result_proc
    ::RegParsec::Regparsers::UpdateStateParser.new.curry!(*regparsers, &result_proc)
  end
end

class RegParsec::Regparsers::UpdateStateParser < RegParsec::Regparsers::Base
  
  def format_args *args
    [ args[0].to_sym,
      try_convert_into_regparser!(args[1]),
      *args[2..-1]
    ]
  end

  def __regparse__ state, binding_variable, regparser
    case result = regparser.regparse( state )
    when Result::Success
      state.merge!(binding_variable => result.return_value) # TODO: result procs
      result
    else
      result
    end
  end
end
