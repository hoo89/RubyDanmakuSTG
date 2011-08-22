# -*- coding: utf-8 -*-
require './stgobjects'
require './stgcommondata'

class StageMainTask
  def initialize
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
  class Base
    @@tasklist=Hash.new
    @@maintask=StageMainTask.new
    def initialize
      STGObj.init
      STGObj.setcommondata(commondata=CommonData.new)
      #commondataに自身をオブザーバとして登録
      #イベントを観測できるようにする?
    end
    
    def update
      @@maintask.update
      STGObj.update
    end
    
    def render
      STGObj.draw
    end
    
    def quit
    end

    def self.use(func_module)
      eval("
      class STGObj
        include #{func_module}
      end
        ",TOPLEVEL_BINDING)
    end

    def self.frame(time,&proc)
      @@maintask.settimetask(time,&proc)
    end
    
    def self.run(name=nil,&proc)
      unless proc.nil? then
        @@maintask.settask(&proc)
      else
        @@maintask.settask(&@@tasklist[name]) 
      end
    end
 
    def self.settask(name,&proc)
      @@tasklist[name]=proc
    end
    
    def self.wait(t)
      t.times do
        Fiber.yield
      end
    end
  end
end
