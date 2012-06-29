require 'spec_helper'

describe do
  include RegParsec::Regparsers

  example do
    state = ::RegParsec::StateAttributes.new(:input => "AaAA", :is_upper => false)

    updown = lazy do |state|
      if state.is_upper
        state.is_upper = false
        /[a-z]/
      else
        state.is_upper = true
        /[A-Z]/
      end
    end
    updown.result_hook! { |match_data| match_data.to_s }

    state.input.should == "AaAA"
    state.is_upper.should be_false
    updown.parse(state).should == 'A'

    state.input.should == "aAA"
    state.is_upper.should be_true
    updown.parse(state).should == 'a'

    state.input.should == "AA"
    state.is_upper.should be_false
    updown.parse(state).should == 'A'

    state.input.should == "A"
    state.is_upper.should be_true
    updown.parse(state).should be_nil

    state.input.should == "A"
    state.is_upper.should be_true
  end
end
