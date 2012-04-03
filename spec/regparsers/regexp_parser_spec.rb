require 'spec_helper'

describe RegParsec::Regparsers::RegexpParser do
  
  subject { described_class.new.curry!(/(.*?);/) }

  example { subject.parse("abc").should be_nil }
  example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }
  example { subject.parse("abc;").should be_nil }
  example { subject.regparse("abc;").should be_is_a ::RegParsec::Result::Accepted }
  example { subject.parse("abc;def;")[0].should == "abc;" }
  example { subject.parse("abc;def;")[1].should == "abc" }
  example { subject.regparse("abc;def;").should be_is_a ::RegParsec::Result::Success }
end