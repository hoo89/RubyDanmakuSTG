class GameToken
  attr_accessor :alive,:parent
  def initialize
    self.alive=true
  end

  def __update
    update
  end
  
  def __draw
    draw
  end
  
  def update
    
  end
  
  def draw
    
  end

  def alive?
    self.alive
  end
  
  def del?
    !alive?
  end
end

class GameNode<GameToken
  def initialize
    super
    @childlist=[]
  end
  
  def childlist
    @childlist
  end
  #private :childlist
  
  def __update
    update
    self.childlist.each{|i|
      i.__update
    }
  end
  
  def __draw
    draw
    self.childlist.each{|i|
      i.__draw
    }
  end
  
  def add_child(node)
    self.childlist<<node
    node.parent=self
  end
  
  def <<(node)
    add_child(node)
  end
  
  def del_child(node)
    self.childlist.delete(node)
  end
end

module Director
  @scenelist=[]
  
  def self.push(scene)
    @scenelist<<scene
    @runscene=@scenelist.last
  end
  
  def self.<<(scene)
    self.push(scene)
  end
  
  def self.pop
    @scenelist.pop
    @runscene=@scenelist.last
  end
  
  def self.replace(scene)
    self.pop
    self.push(scene)
  end
  
  def self.run(scene)
    push(scene)
    Window.loop do
      @runscene.__update
      @runscene.__draw
    end
    
  end
end