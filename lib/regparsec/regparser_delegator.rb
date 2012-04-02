require 'regparsec'

module RegParsec::RegparserDelegatable
  
  include ::RegParsec::Regparseable

  def regular_object
    @_regparser_regobj ||= ::RegParsec::RegparserHelpers.try_convert_into_regparser!(__build_regparser__)
  end
  
  def __build_regparser__
    raise NotImplementedError, "need to define `__build_regparser__'"
  end
  
  def format_args *args
    args
  end
  
  def __regparse__ *args, &block
    regular_object.regparse *args, &block
  end
  
  def __parse__ *args, &block
    regular_object.parse *args, &block
  end
end

class RegParsec::RegparserDelegator

  include ::RegParsec::RegparserDelegatable
  
  def initialize regparser
    @_regparser_regobj = ::RegParsec::RegparserHelpers.try_convert_into_regparser!(regparser)
  end
  
  def __build_regparser__
    @_regparser_regobj
  end
end