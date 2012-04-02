require 'spec_helper'

describe ::RegParsec::Regparser do
  subject { described_class.new("abc") }

  example { subject.parse("abc").should == ["abc"] }
  example { subject.regparse("abc").should == ::RegParsec::Result::Success.new( :return_value => ["abc"], :matching_string => "abc" ) }
  example { subject.parse("abcabc").should == ["abc", "abc"] }
  example { subject.regparse("abcabc").should == ::RegParsec::Result::Success.new( :return_value => ["abc", "abc"], :matching_string => "abcabc" ) }
  example { subject.parse("def").should be_nil }
  example { subject.regparse("def").should == ::RegParsec::Result::Invalid.new }
  example { subject.parse("abcdef").should == ["abc"] }
  example { subject.regparse("abcdef").should == ::RegParsec::Result::Success.new( :return_value => ["abc"], :matching_string => "abc" ) }
  example { subject.parse("abcab").should == ["abc"] }
  example { subject.regparse("abcab").should == ::RegParsec::Result::Success.new( :return_value => ["abc"], :matching_string => "abc" ) }
end