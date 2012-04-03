require 'spec_helper'

describe RegParsec::Regparsers::BetweenParser do
  
  subject { described_class.new.curry!('"', '"', "abc") }

  example { subject.parse(%q_"abc"_).should == "abc" }
  example { subject.regparse(%q_"abc"_).should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => %q_"abc"_ ) }
  example { subject.parse(%q_"abc" "abc"_).should == "abc" }
  example { subject.regparse(%q_"abc" "abc"_).should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => %q_"abc"_ ) }
  example { subject.parse(%q_"a"_).should == nil }
  example { subject.regparse(%q_"a"_).should == ::RegParsec::Result::Invalid.new }
  example { subject.parse(%q_"abcd"_).should == nil }
  example { subject.regparse(%q_"abcd"_).should == ::RegParsec::Result::Invalid.new }
  example { subject.parse("abc").should == nil }
  example { subject.regparse("abc").should == ::RegParsec::Result::Invalid.new }
  example { subject.parse(%q_abc"_).should == nil }
  example { subject.regparse(%q_abc"_).should == ::RegParsec::Result::Invalid.new }
  example { subject.parse(%q_"abc_).should == nil }
  example { subject.regparse(%q_"abc_).should == ::RegParsec::Result::Accepted.new( :return_value => "abc", :matching_string => %q_"abc_) }
end
