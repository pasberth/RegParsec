require 'spec_helper'

describe RegParsec::Regparsers::RegexpParser do
  
  context ' /(.*?);/ case ' do
    subject { described_class.new.curry!(/(.*?);/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }
    example { subject.parse("abc;")[0].should == "abc;" }
    example { subject.parse("abc;")[1].should == "abc" }
    example { subject.regparse("abc;").should be_is_a ::RegParsec::Result::Valid }
    example { subject.parse("abc;def;")[0].should == "abc;" }
    example { subject.parse("abc;def;")[1].should == "abc" }
    example { subject.regparse("abc;def;").should be_is_a ::RegParsec::Result::Success }
  end
  
  context ' /./ case ' do
    subject { described_class.new.curry!(/./) }

    example { subject.parse("a")[0].should == "a" }
    example { subject.regparse("a").should be_is_a ::RegParsec::Result::Valid }
    example { subject.parse("ab")[0].should == "a" }
    example { subject.regparse("ab").should be_is_a ::RegParsec::Result::Success }
    example { subject.parse("").should be_nil }
    example { subject.regparse("").should be_is_a ::RegParsec::Result::Invalid }
  end
  
  context ' /.*/ case ' do
    subject { described_class.new.curry!(/.*/) }

    example { subject.parse("abc")[0].should == "abc" }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Valid }
    example { subject.parse("abc\n")[0].should == "abc" }
    example { subject.regparse("abc\n").should be_is_a ::RegParsec::Result::Success }
    example { subject.parse("abc\ndef")[0].should == "abc" }
    example { subject.regparse("abc\ndef").should be_is_a ::RegParsec::Result::Success }
    example { subject.parse("abc\ndef\n")[0].should == "abc" }
    example { subject.regparse("abc\ndef\n").should be_is_a ::RegParsec::Result::Success }
  end
  
  context ' /#(.*)\n/ case ' do
    subject { described_class.new.curry!(/\#(.*?)\n/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }

    example { subject.parse("# abc\n")[0].should == "# abc\n" }
    example { subject.parse("# abc\n")[1].should == " abc" }
    example { subject.regparse("# abc\n").should be_is_a ::RegParsec::Result::Valid }

    example { subject.parse("# abc\n def")[0].should == "# abc\n" }
    example { subject.parse("# abc\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n def").should be_is_a ::RegParsec::Result::Success }
  end
  
  context ' /#(.*)\n+/ case ' do
    subject { described_class.new.curry!(/\#(.*?)\n+/) }

    example { subject.parse("abc").should be_nil }
    example { subject.regparse("abc").should be_is_a ::RegParsec::Result::Invalid }

    example { subject.parse("# abc\n")[0].should == "# abc\n" }
    example { subject.parse("# abc\n")[1].should == " abc" }
    example { subject.regparse("# abc\n").should be_is_a ::RegParsec::Result::Valid }

    example { subject.parse("# abc\n def")[0].should == "# abc\n" }
    example { subject.parse("# abc\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n def").should be_is_a ::RegParsec::Result::Success }

    example { subject.parse("# abc\n\n\n")[0].should == "# abc\n\n\n" }
    example { subject.parse("# abc\n\n\n")[1].should == " abc" }
    example { subject.regparse("# abc\n\n\n").should be_is_a ::RegParsec::Result::Valid }

    example { subject.parse("# abc\n\n\n def")[0].should == "# abc\n\n\n" }
    example { subject.parse("# abc\n\n\n def")[1].should == " abc" }
    example { subject.regparse("# abc\n\n\n def").should be_is_a ::RegParsec::Result::Success }
  end
end