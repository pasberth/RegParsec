$:.unshift File.dirname(__FILE__) + '/../lib'
require 'regparsec'

StringParser = RegParsec::Regparsers.between('"', '"', /(?:(?:\\\")|[^"])*/)
p StringParser.parse('"this is a string"')
# => #<MatchData "this is a string"> 
p StringParser.parse('"can escape the \" !"')
# => #<MatchData "can escape the \\\" !"> 

QuoteParser = RegParsec::Regparsers.instance_eval do
  between( apply( 'q',
                  update do |state|
                    state.quotation_mark = apply(/./, &:join).parse(state)
                  end ),
           lazy(&:quotation_mark),
           lazy do |state|
             q = Regexp.quote( state.quotation_mark )  # "\"" => "\\\""
             /(?:(?:\\#{ q })|[^#{ q }])*/             # /(?:(?:\\\")|[^"])*/
           end ) do
    |body| body[0].to_s
  end
end

p QuoteParser.parse('q"the double quotation!"')
# => "the double quotation!"
p QuoteParser.parse('q# the quotation by number marks! #')
# => " the quotation by number marks! "
