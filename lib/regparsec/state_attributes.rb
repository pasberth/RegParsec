require 'regparsec'

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

  private
    def commits
      @commits ||= []
    end
end