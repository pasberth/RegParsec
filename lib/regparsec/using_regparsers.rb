require 'regparsec'

class RegParsec::UsingRegparsers

  def initialize using_regparsers={}
    @regps = using_regparsers
  end
  
  def define method, regparser
    method.respond_to?(:to_sym) ? method = method.to_sym : raise(TypeError, "Can't convert #{method.class} into Regparser")
    @regparsers[method] = regparser
    instance_eval(<<-DEFINE)
      def #{method}
        @regparsers[:'#{method}']
      end
    DEFINE
    regparser
  end
end