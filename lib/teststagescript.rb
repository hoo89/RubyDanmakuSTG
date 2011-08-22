require './stagescriptbase'
load './stgimageload.rb'
class Stage1<TohoStage #ステージのルーチンを記述する場所
  module Func
    def fire(spd,ang,image=WHITEBUL)
      Bullet.new.setpos(@x,@y).setspeed(spd,ang).setimage(image)
    end
    def fireobj(&proc)
      ShootObj.new(&proc).setpos @x,@y
    end
    def nway(dir,way,span,image=WHITEBUL)
      angle = dir - (way - 1) / 2 * span;
      way.times {
        fire(3,angle,image)
        angle += span
      }
    end
  end
  
  use Func

  frame 0 do
    Player.new.setpos(200,400)
    #render_background(:Stage1_1)
    run :task1
  end

  settask :task1 do
    5.times do |i|
      Enemy.new{
        @x=0
        @y=100
        @dx=2
        @image=WHITEBUL
        wait 30
        3.times do
          nway(aim,5,10,TESTIMAGE)
          wait 30
        end
        quit
      }
      wait 30
    end
  end

end
