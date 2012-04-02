require 'spec_helper'

describe RegParsec::Regparsers::StringParser do
  
  subject { described_class.new.curry!("abc") }

  example { subject.parse("abc").should == "abc" }
  example { subject.regparse("abc").should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => "abc" ) }
  example { subject.parse("ab").should be_nil }
  example { subject.regparse("ab").should == ::RegParsec::Result::Accepted.new( :return_value => "ab", :matching_string => "ab" ) }
  example { subject.parse("abcd").should == "abc" }
  example { subject.regparse("abcd").should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => "abc" ) }
  example { subject.parse("d").should be_nil }
  example { subject.regparse("d").should == ::RegParsec::Result::Invalid.new }
  example { subject.parse("abd").should be_nil }
  example { subject.regparse("abd").should == ::RegParsec::Result::Invalid.new }
end