require 'spec_helper'

describe ::RegParsec::Regparsers::GiveStateParser do
  subject { described_class.new.curry(:x, ::RegParsec::Regparsers.apply) }

  example { subject.parse( :input => 'abc', :x => 'abc' ).should == ["abc"] }
  example { subject.regparse( :input => 'abc', :x => 'abc' ).should == ::RegParsec::Result::Success.new( :return_value => ['abc'], :matching_string => 'abc' ) }
  example { subject.parse( :input => 'def', :x => 'abc' ).should be_nil }
  example { subject.regparse( :input => 'def', :x => 'abc' ).should == ::RegParsec::Result::Invalid.new }
end
