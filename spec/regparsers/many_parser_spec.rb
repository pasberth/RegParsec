require 'spec_helper'

describe RegParsec::Regparsers::ManyParser do
  subject { described_class.new.curry!("abc") }

  example { subject.parse("abc").should be_nil }
  example { subject.regparse("abc").should == ::RegParsec::Result::Accepted.new( :return_value => ["abc", ""], :matching_string => "abc" ) }
  example { subject.parse("a").should be_nil }
  example { subject.regparse("a").should == ::RegParsec::Result::Accepted.new( :return_value => ["a"], :matching_string => "a" ) }
  example { subject.parse("abca").should be_nil }
  example { subject.regparse("abca").should == ::RegParsec::Result::Accepted.new( :return_value => ["abc", "a"], :matching_string => "abca" ) }
  example { subject.parse("d").should == [] }
  example { subject.regparse("d").should == ::RegParsec::Result::Success.new( :return_value => [], :matching_string => "" ) }
  example { subject.parse("abcd").should == ["abc"] }
  example { subject.regparse("abcd").should == ::RegParsec::Result::Success.new( :return_value => ["abc"], :matching_string => "abc" ) }
end
