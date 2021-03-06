# -*- coding: utf-8 -*-
require './stgobjects'

class StageMainTask<GameToken
  def initialize
    super
    @maintasks=[]
    @maintasklist=Hash.new
    @tasks=[]
    @frame=0
  end
  
  def settask(&proc)
    @tasks<<Fiber.new(&proc)
  end
  
  def settimetask(time,&proc)
    @maintasklist[time]=proc
  end
  
  def resumemaintasks
    @maintasks.delete_if{|i|
      !i.alive?
    }
    @maintasks.each{|i|
      i.resume
    }
  end
  
  def resumetasks
    @tasks.delete_if{|i|
      !i.alive?
    }
    @tasks.each{|i|
      i.resume
    }
  end
  
  def update
    if @maintasklist.key?(@frame) then
      @maintasks<<Fiber.new(&@maintasklist[@frame])
    end
    resumemaintasks
    resumetasks
    @frame+=1
  end
  
  def wait(t)
    t.times{
      Fiber.yield
    }
  end
end

class Stage #ステージのルーチンを記述する場所
  class Base<GameNode

    def self.tasklist
      @tasklist
    end
    
    def self.stagetask
      @stagetask
    end
    
    def self.frame(time,&proc)
      unless @stagetask then
        @stagetask=StageMainTask.new
      end
      @stagetask.settimetask(time,&proc)
    end
    
    def self.run(name=nil,&proc)
      unless proc.nil? then
        @stagetask.settask(&proc)
      else
        @stagetask.settask(&@tasklist[name]) 
      end
    end
 
    def self.settask(name,&proc)
      unless @tasklist then
        @tasklist=Hash.new
      end
      @tasklist[name]=proc
    end
    
    def self.wait(t)
      t.times do
        Fiber.yield
      end
    end
    
    def self.use(func_module)
      eval("
      class STGObj
        include #{func_module}
      end
        ",TOPLEVEL_BINDING)
    end

    
    def initialize
      super
      self<<@stagetask=self.class.stagetask.clone
      self<<@stgobjlayer=STGObjManager.new
      STGObj.setparent(@stgobjlayer)
    end
    
    def quit
    end
    
  end
end
