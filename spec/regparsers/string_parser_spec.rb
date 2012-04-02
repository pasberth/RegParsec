require 'spec_helper'

describe RegParsec::Regparsers::StringParser do
  
  subject { described_class.new.curry!("aaa") }

  example { subject.parse("aaa").should == "aaa" }
  example { subject.regparse("aaa").should == ::RegParsec::Result::Success.new( :return_value => "aaa", :matching_string => "aaa" ) }
end