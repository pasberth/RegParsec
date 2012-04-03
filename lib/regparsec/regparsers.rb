require 'regparsec'
require 'regparsec/regparseable'

module RegParsec

  module Regparsers
    extend self
  end
  
  module Regparseable
    include Regparsers
  end
end

require 'regparsec/parser/base'
require 'regparsec/parser/state'
require 'regparsec/parser/primary_parsers'
require 'regparsec/parser/combinators'