require 'spec_helper'

describe RegParsec::Regparsers::Many1Parser do
  subject { described_class.new.curry!("abc") }

  example { subject.parse("abc").should == ["abc"] }
  example { subject.regparse("abc").should == ::RegParsec::Result::Valid.new( :return_value => ["abc"], :matching_string => "abc" ) }
  example { subject.parse("a").should be_nil }
  example { subject.regparse("a").should == ::RegParsec::Result::Accepted.new( :return_value => "a", :matching_string => "a" ) }
  example { subject.parse("abca").should == ["abc"] }
  example { subject.regparse("abca").should == ::RegParsec::Result::Valid.new( :return_value => ["abc"], :matching_string => "abc" ) }
  example { subject.parse("d").should be_nil }
  example { subject.regparse("d").should == ::RegParsec::Result::Invalid.new }
  example { subject.parse("abcd").should == ["abc"] }
  example { subject.regparse("abcd").should == ::RegParsec::Result::Success.new( :return_value => ["abc"], :matching_string => "abc" ) }
end
