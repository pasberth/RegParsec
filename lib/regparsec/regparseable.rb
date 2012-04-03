require 'regparsec'

module RegParsec::Regparseable
  
  [ :regparse, :parse ].each do |method|
    class_eval(<<-DEFINE)
      def __#{method}__(*args, &block)
        raise NotImplementedError, "need to define `#{method}'"
      end
    DEFINE
  end

  def regparse state
    __regparse__ ::RegParsec::RegparserHelpers.build_state_attributes(state), *format_args(*curried_args)
  end
  
  def parse state
    __parse__ ::RegParsec::RegparserHelpers.build_state_attributes(state), *format_args(*curried_args)
  end

  def __parse__ state, *args
    case result = regparse(state)
    when ::RegParsec::Result::Success
      if result_procs.empty?
        result.return_value
      else
        result_procs[0].call result.return_value
      end
    else
      nil
    end
  end

  def format_args *args
    args.map &:try_convert_into_regparser!.in(::RegParsec::RegparserHelpers)
  end

  def curried_args
    @_curried_args ||= []
  end
  
  def result_procs
    @_result_proc ||= []
  end
  
  def curry *args, &block
    clone.curry! *args, &block
  end
  
  def curry! *args, &result_proc
    args.each &:push.to(curried_args)
    result_procs << result_proc if result_procs.empty? and result_proc
    self
  end
  
  def to_regparser
    self
  end
end