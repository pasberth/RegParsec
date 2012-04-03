require 'regparsec/regparsers'

module RegParsec::Regparsers


  [ [:update_state, :UpdateStateParser],
    [:give_state, :GiveStateParser]
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
      state.merge!(binding_variable => result.return_value)
      result
    else
      result
    end
  end
end

class RegParsec::Regparsers::GiveStateParser < RegParsec::Regparsers::Base
  
  def format_args *args
    [ args[0].to_sym,
      try_convert_into_regparser!(args[1]),
      *args[2..-1]
    ]
  end

  def __regparse__ state, binding_variable, regparser
    regparser.curry( state[binding_variable] ).regparse( state )
  end
end
