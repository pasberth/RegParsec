require 'spec_helper'

describe RegParsec::Regparsers::OneOfParser do
  subject { described_class.new.curry!("abc", "def") }

  example { subject.parse("abc").should == "abc" }
  example { subject.regparse("abc").should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => "abc" ) }
  example { subject.parse("a").should == nil }
  example { subject.regparse("a").should == ::RegParsec::Result::Accepted.new( :return_value => "a", :matching_string => "a" ) }
  example { subject.parse("def").should == "def" }
  example { subject.regparse("def").should == ::RegParsec::Result::Success.new( :return_value => "def", :matching_string => "def" ) }
  example { subject.parse("d").should == nil }
  example { subject.regparse("d").should == ::RegParsec::Result::Accepted.new( :return_value => "d", :matching_string => "d" ) }
  example { subject.regparse("abcdef").should == ::RegParsec::Result::Success.new( :return_value => "abc", :matching_string => "abc" ) }
  example { subject.parse("abcdef").should == "abc" }
  example { subject.regparse("defabc").should == ::RegParsec::Result::Success.new( :return_value => "def", :matching_string => "def" ) }
  example { subject.parse("defabc").should == "def" }
end