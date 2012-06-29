require 'regparsec'
require 'regparsec/regparsers'

class RegParsec::Regparsers::Base
  
  include RegParsec
  include RegParsec::RegparserHelpers
  include RegParsec::Regparseable
end