require 'spec_helper'

describe ::RegParsec::Regparsers::UpdateStateParser do
  subject { described_class.new.curry(:x, "abc") }
  let(:state) { ::RegParsec::StateAttributes.new( :x => '' ) }

  example do
    state.input = "abc"
    subject.parse( state )
    state.x.should == "abc"
  end

  example do
    state.input = "def"
    subject.parse( state )
    state.x.should == ''
  end
end
