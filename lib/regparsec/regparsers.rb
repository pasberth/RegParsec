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

require 'regparsec/regparsers/base'
require 'regparsec/regparsers/state'
require 'regparsec/regparsers/primary_parsers'
require 'regparsec/regparsers/combinators'
