require 'spec_helper'

describe RegParsec::Regparsers::RegexpParser do
  
  context ' /(.*?);/ case ' do
    subject { described_class.new.curry!(/(.*?);/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }
    example { subject.parse("abc;").should be_nil }
    example { subject.regparse("abc;").should be_is_a ::RegParsec::Result::Accepted }
    example { subject.parse("abc;def;")[0].should == "abc;" }
    example { subject.parse("abc;def;")[1].should == "abc" }
    example { subject.regparse("abc;def;").should be_is_a ::RegParsec::Result::Success }
  end
  
  context ' /#(.*)\n/ case ' do
    subject { described_class.new.curry!(/\#(.*?)\n/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }

    example { subject.parse("# abc\n").should be_nil }
    example { subject.regparse("# abc\n").should be_is_a ::RegParsec::Result::Accepted }

    example { subject.parse("# abc\n def")[0].should == "# abc\n" }
    example { subject.parse("# abc\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n def").should be_is_a ::RegParsec::Result::Success }
  end
  
  context ' /#(.*)\n+/ case ' do
    subject { described_class.new.curry!(/\#(.*?)\n+/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }

    example { subject.parse("# abc\n").should be_nil }
    example { subject.regparse("# abc\n").should be_is_a ::RegParsec::Result::Accepted }

    example { subject.parse("# abc\n def")[0].should == "# abc\n" }
    example { subject.parse("# abc\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n def").should be_is_a ::RegParsec::Result::Success }

    example { subject.parse("# abc\n\n\n").should be_nil }
    example { subject.regparse("# abc\n\n\n").should be_is_a ::RegParsec::Result::Accepted }

    example { subject.parse("# abc\n\n\n def")[0].should == "# abc\n\n\n" }
    example { subject.parse("# abc\n\n\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n\n\n def").should be_is_a ::RegParsec::Result::Success }
  end
end