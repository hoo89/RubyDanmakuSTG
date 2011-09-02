require './drawer'
require './gametoken'
require './stgbasemod'

require 'dxrubyex'

class Array
  include ArrayExtension
end

#STGObjの登録、更新、描画、削除を担当するクラス
class STGObjManager<GameNode
  MAX_OBJECT=1000
  #弾の登録
  def add_child(obj)
    #弾数の上限はここで管理してる
    #return if @objlist.length>MAX_OBJECT&&obj.type==:enemybullet
    childlist<<obj
  end
  #弾の更新,削除
  def __update
    childlist.hs_delete_if(:__delete)
    childlist.hs_each(:update)
  end
  #描画
  def __draw
    childlist.hs_each(:draw)
    #    #デバッグ用
    #    @fnt = Font.new("Objcount:"+@objlist.length.to_s)
    #    @fnt2 = Font.new("FPS:"+real_fps().to_s)
    #    @fnt2.y=12
    #    @fnt.render
    #    @fnt2.render
  end
  #当たり判定　当たったときdのtypeを持つSTGObjのhitメソッドを呼び出す
  def hit_check(o,d)
    @o=childlist.select{|i| i.type==o }.map{|i| i.collision }
    @d=childlist.select{|i| i.type==d }.map{|i| i.collision }
    Collision.check(@o,@d)
    #@fnt3 = Font.new(@o.length.to_s+"と"+@d.length.to_s)
    #@fnt3.y=24
    #@fnt3.render
  end
  #今のままだとupdate中にsendされるため何が先に実行されるか分からない
  #改善予定?
  def send(tag,&proc)
    childlist.select{|x|x.type==tag}.each{|i|
      proc.call(i)
    }
  end
end

#当たり判定をもつ,あるいは持つ可能性がある画面上のオブジェクトが継承するクラス
class STGObj<GameToken
  attr_accessor :x, :y, :dx, :dy,:type,:collision,:image
  include BaseAct

  def self.setparent(parent)
    @@parent=parent
  end
  
  def initialize(*arg,&proc)
    super
    @w=@h=@dx=@dy=@angle=0.0
    @@parent<<self
    init(*arg,&proc)
  end
  
  def init(*arg,&proc)
  end
  
  def update
    mainloop
    move
  end
  
  def move
    @x+=@dx
    @y+=@dy
    #@collision.set(@x,@y)
  end
  
  def mainloop
  end
  
  #drawの実装に関しては考え中
  include Drawer
  def draw
    return if @image.nil?
    if (@image.hasangle?) then
      @angle=getangle unless getangle.nil?
      Drawer.draw(@x,@y,@image,@angle)
    else
      Drawer.draw(@x,@y,@image)
    end
  end
  
  #当たり判定時、当たった際に呼び出される関数 当たったSTGObjがoで渡される
  def hit(o)
  end
  
  def shot(d)
  end
  
  def send(tag,&proc)
    @@parent.send(tag,&proc)
  end
  
  def __delete
    outofscreen?||!alive
  end
end

class Bullet < STGObj
  def init(x=0,y=0)
    @x=x
    @y=y
    @type=:enemybullet#仮
    #@w=@h=3
    @image=WHITEBUL
    @collision=CollisionPoint.new( self)
  end
end

class Player < STGObj
  def init
    @type=:player
    #@w=@h=9
    @speed=2
    @r2speed=Math.sqrt(2)*@speed/2
    @image=WHITEBUL
    #@collision=CollisionCircle.new( self, 0, 0, 4 )
  end
  
  def mainloop
    if Input.x*Input.y!=0 then
      @dx=@r2speed*Input.x
      @dy=@r2speed*Input.y
    else
      @dx=@speed*Input.x
      @dy=@speed*Input.y
    end
  end
  
  def hit(o)
    @delete=true
  end
end

require 'fiber'
class ShootObj<STGObj
  def init(option=nil,&func)
    @tasks=[]
    setfiber(option,&func)
    resume
  end
  
  def mainloop
    resume
  end
  
  def resume
    @tasks.each{|i|
      i.resume if i.alive?
    }
  end
  
  def setfiber(option=nil,&func)
    @tasks<<Fiber.new{
      instance_exec(option,&func)
    }
  end
  
  def wait(i)
    i.times do
      Fiber.yield
    end
  end
end