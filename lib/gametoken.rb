class GameToken
  attr_accessor :alive
  def initialize
    self.class.maneger.settoken(self)
    self.alive=true
  end
  
  def update
    
  end
  
  def render
    
  end
  
  def self.update
    maneger.update
  end
  
  def self.draw
    maneger.draw
  end
  
  def self.setmaneger(mng)
    
  end
  
  def alive?
    self.alive
  end
  
  def del?
    !alive?
  end
  
end