require 'regparsec'

module RegParsec::Regparseable
  
  [ :regparse, :parse ].each do |method|
    class_eval(<<-DEFINE)
      def __#{method}__(*args, &block)
        raise NotImplementedError, "need to define `__#{method}__'"
      end
    DEFINE
  end

  def regparse state
    result = __regparse__ ::RegParsec::RegparserHelpers.build_state_attributes(state), *format_args(*curried_args)
    case result
    when ::RegParsec::Result::Success, ::RegParsec::Result::Valid
      result.return_value = result_hooks.inject(result.return_value) { |r, hook| hook.call(r) }
      update_procs.each { |proc| proc.call(state, result.return_value) }
    end
    result
  end
  
  def parse state
    __parse__ ::RegParsec::RegparserHelpers.build_state_attributes(state), *format_args(*curried_args)
  end

  def __parse__ state, *args
    case result = regparse(state)
    when ::RegParsec::Result::Success, ::RegParsec::Result::Valid
      result.return_value
    else
      nil
    end
  end

  def format_args *args
    args.map &:try_convert_into_regparser!.in(::RegParsec::RegparserHelpers)
  end
  
  def update &block
    clone.update! &block
  end

  def update! &block
    update_procs << block || raise(ArgumentError, "tried to update states without a block.")
    self
  end

  def result_hook &block
    clone.result_hook! &block
  end

  def result_hook! &hook
    result_hooks << hook || raise(ArgumentError, "tried to put a result hook without a block.")
  end
  
  def curry! *args, &block
    args.each &:push.to(curried_args)
    # TODO: How will using to the block
    # result_procs << result_proc if result_procs.empty? and result_proc
    self
  end
  
  def curry *args, &block
    clone.curry! *args, &block
  end
  
  def clone
    cln = super
    cln.curried_args = curried_args.clone
    cln.result_hooks = result_hooks.clone
    cln
  end
  
  def to_regparser
    self
  end

  protected

    def curried_args= a
      @_curried_args = a
    end

    def curried_args
      @_curried_args ||= []
    end

    def update_procs= a
      @_update_procs = a
    end

    def update_procs
      @_update_procs ||= []
    end
  
    def result_hooks= a
      @_result_hooks = a
    end

    def result_hooks
      @_result_hooks ||= []
    end
end
