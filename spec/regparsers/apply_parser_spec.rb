require 'spec_helper'

describe RegParsec::Regparsers::ApplyParser do
  
  subject { described_class.new.curry!("abc", "def") }

  example { subject.parse("abc").should == nil }
  example { subject.regparse("abc").should == ::RegParsec::Result::Accepted.new( :return_value => ["abc", ""], :matching_string => "abc" ) }
  example { subject.parse("a").should == nil }
  example { subject.regparse("a").should == ::RegParsec::Result::Accepted.new( :return_value => ["a"], :matching_string => "a" ) }
  example { subject.parse("abcd").should == nil }
  example { subject.regparse("abcd").should == ::RegParsec::Result::Accepted.new( :return_value => ["abc", "d"], :matching_string => "abcd" ) }
  example { subject.regparse("abcdef").should == ::RegParsec::Result::Success.new( :return_value => ["abc", "def"], :matching_string => "abcdef" ) }
  example { subject.parse("abcdef").should == ["abc", "def"] }
  example { subject.regparse("def").should == ::RegParsec::Result::Invalid.new }
  example { subject.parse("def").should == nil }
end
