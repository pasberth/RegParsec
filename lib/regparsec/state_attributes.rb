require 'regparsec'

module RegParsec::StateAttributesHelpers
  
  def try_convert_into_state_attributes! attributes
    case attributes
    when ::RegParsec::StateAttributes then attributes
    when ::Hash then ::RegParsec::StateAttributes.new(attributes)
    else raise TypeError, "Can't convert #{attributes.class} into RegParsec::StateAttributes"
    end
  end
end

class RegParsec::StateAttributes
  
  def initialize attributes={}
    commit! attributes
  end
  
  def [] *args, &block
    @head.send :[], *args, &block
  end
  
  def []= *args, &block
    @head.send :[]=, *args, &block
  end
  
  def method_missing f, *args, &block
    if f.to_s =~ /^(.*?)(\=)?$/ and @head.keys.map(&:to_sym).include? $1.to_sym or $2
      send :"[]#{$2}", $1.to_sym, *args, &block
    else
      super
    end
  end
  
  def checkout! commit
    @head = Hash[*commit.map { |key, val| [key, (val.clone rescue val)] }.flatten(1)]
    true
  end

  def backdate!
    checkout! commits.pop
  end
  
  def refresh!
    checkout! commits.last
  end

  def commit! commit = @head
    commits << commit
    refresh!
  end
  
  def merge! commit
    commit! merge commit
  end

  protected
  
    def head
      @head
    end
    
    def updated_commit
      commits.last
    end

  private

    def commits
      @commits ||= []
    end

    def merge commit
      commit = case commit
               when ::RegParsec::StateAttributes then commit.updated_commit
               when Hash then commit
               end
      @head.merge(commit)
    end
end