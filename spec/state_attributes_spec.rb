require 'spec_helper'

describe ::RegParsec::StateAttributes do
  
  context "Getting and Setting to the :x" do

    subject { described_class.new(:x => 0) }

    example { subject[:x].should == 0 }
    example { subject[:x] = 1; subject[:x].should == 1 }
    example { subject[:y].should be_nil }
    example { subject[:y] = 1; subject[:y].should == 1 }

    example { expect { subject.x }.should_not raise_error NoMethodError }
    example { expect { subject.x = 0 }.should_not raise_error NoMethodError }
    example { expect { subject.y }.should raise_error NoMethodError }
    example { expect { subject.y = 0 }.should_not raise_error NoMethodError }
    example { subject.y = 1; expect { subject.y }.should_not raise_error NoMethodError }

    example { subject.x.should == 0 }
    example { subject.x = 1; subject.x.should == 1 }
    example { subject.y = 1; subject.y.should == 1 }
  end

  context "Substitute and Refresh" do

    subject { described_class.new(:x => 0) }

    example { subject.x == 0 } 
    example { subject.x = 1; subject.x == 1 }

    example { subject.x = 1; subject.refresh!; subject.x == 0 } 
    example { subject.x = 1; subject.refresh!; subject.commit!; subject.x == 0 } 

    example { subject.x = 1; subject.commit!; subject.x == 1 } 
    example { subject.x = 1; subject.commit!; subject.refresh!; subject.x == 1 } 

    example { subject.x = 1; subject.commit!; subject.backdate!; subject.x == 1 }
    example { subject.x = 1; subject.commit!; subject.backdate!; subject.refresh!; subject.x == 0  }
  end

  context "Destructive change and Refresh" do
    
    subject { described_class.new(:x => 'a') }

    example { subject.x == 'a' } 
    example { subject.x << 'b'; subject.x == 'ab' }

    example { subject.x << 'b'; subject.refresh!; subject.x == 'a' } 
    example { subject.x << 'b'; subject.refresh!; subject.commit!; subject.x == 'a' } 

    example { subject.x << 'b'; subject.commit!; subject.x == 'ab' } 
    example { subject.x << 'b'; subject.commit!; subject.refresh!; subject.x == 'ab' } 

    example { subject.x << 'b'; subject.commit!; subject.backdate!; subject.x == 'ab' }
    example { subject.x << 'b'; subject.commit!; subject.backdate!; subject.refresh!; subject.x == 'a'  }
  end
end