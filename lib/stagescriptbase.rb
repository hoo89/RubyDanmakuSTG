require './stagebase'

module BaseBulletmod
  def quit
    @alive=false
    @quit_proc.call if @quit_proc 
  end
  def when_quit(&proc)
    @quit_proc=proc
  end
end

class STGObj<GameToken
  def update #もとの基底オブジェクトに機能追加するのにもっといい方法ないものか
     mainloop
     move
    @collision.set(x,y) if @collision
  end
end

class TohoStage<Stage::Base

  class Enemy<ShootObj
    def initialize(*args,&proc)
      super
      @type=:enemy
    end
  end
  class KariPlayer<Player
    def init(*args,&proc)
      super
      @collision=CollisionCircle.new( self, 0, 0, 4 )
    end
    def hit(s)
      #p "hitted #{s}"
    end
  end
  
  Player=KariPlayer
  
  def initialize(commondata=nil)
    STGObj.init
    if commondata then
      STGObj.setcommondata(commondata)
    else
      STGObj.setcommondata(CommonData.new)
    end
    TohoStage.use BaseBulletmod
    
  end
  
  def update
    super
    STGObj.hit_check(:enemybullet,:player)
  end
end
