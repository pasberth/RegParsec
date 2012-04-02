require 'regparsec'

module RegParsec::Regparseable

  [ :regparse, :parse ].each do |method|
    class_eval(<<-DEFINE)
      def __#{method}__(*args, &block)
        raise NotImplementedError, "need to define `#{method}'"
      end
    DEFINE
  end
  
  def regparse input
    __regparse__ input, *format_args(*curried_args)
  end
  
  def parse input
    __parse__ input, *format_args(*curried_args)
  end

  def __parse__ input, *args
    case result = regparse(input)
    when ::RegParsec::Result::Success
      result.return_value
    else
      nil
    end
  end

  def format_args *args
    args.map &:try_convert_into_regparser.in(::RegParsec::RegparserHelpers)
  end

  def curried_args
    @_curried_args ||= []
  end
  
  def curry *args, &block
    clone.curry! *args, &block
  end
  
  def curry! *args, &block
    args.each &:push.to(curried_args)
    block and curried_args << block
    self
  end
end