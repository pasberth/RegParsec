require 'regparsec'

module RegParsec

  module Regparsers

    extend self

    require 'regparsec/parser/base'
    require 'regparsec/parser/state'
    require 'regparsec/parser/primary_parsers'
    require 'regparsec/parser/combinators'
  end
end
