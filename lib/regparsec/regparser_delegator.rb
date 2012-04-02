require 'regparsec'

module RegParsec::RegparserDelegator

  def regular_object
    @_regparser_regobj ||= __build_regparser__
  end
  
  def __build_regparser__
    raise NotImplementedError, "need to define `__build_regparser__'"
  end
  
  [ :__regparse__, :regparse,
    :__parse__, :parse,
    :curry, :curry!
  ].each do |method|
    class_eval(<<-DEFINE)
      def #{method}(*args, &block)               # def __regparse__(*args, &block)
        regular_object.#{method}(*args, &block)  #   regular_object.__regparse__(*args, &block)
      end                                        # end
    DEFINE
  end
end
