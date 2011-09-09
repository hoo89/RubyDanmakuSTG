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
    def update
      super
      parent.playerpos=[self.x,self.y]
    end
  end
  
  Player=KariPlayer
  
  def initialize
    super
    #    if commondata then
    #      STGObj.setcommondata(commondata)
    #    else
    #      STGObj.setcommondata(CommonData.new)
    #    end
    TohoStage.use BaseBulletmod
    
    def @stgobjlayer.playerpos=(pos)
      @ppos=pos
    end
    
    def @stgobjlayer.playerpos
      @ppos||[0,0]
    end
  end
  
  def update
    super
    @stgobjlayer.hit_check(:enemybullet,:player)
  end
end
