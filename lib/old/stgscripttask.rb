require 'fiber'

module GemTask
  def enemy(option=nil,&proc)
    proc{
      ShootObj.new(option,&proc)
    }
  end
  def task(&proc)
    proc
  end
  def wait(t)
    t.times do
      Fiber.yield
    end
  end
end

class StageTask
  def initialize(table,objtable)
    @table=table
    @objtable=objtable
    @tasks=[]
    @maintask=Fiber.new{
      table.size.times do |i|
        unless table[i]=="-"
          @tasks<<Fiber.new(&objtable[table[i].to_sym])
        end
        wait(60)
      end
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
    @maintask.resume if @maintask.alive?
    resumetasks
  end
  def wait(t)
    t.times{
      Fiber.yield
    }
  end
end