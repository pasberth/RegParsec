require 'spec_helper'

describe RegParsec::Regparsers::StringParser do
  
  subject { described_class.new("aaa") }

  example { subject.parse("aaa").should == "aaa" }
  example { subject.regparse("aaa").should == ::RegParsec::Result::Success.new( :matching_string => "aaa" ) }
end