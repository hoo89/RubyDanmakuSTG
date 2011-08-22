require './stagebase'
class Bullet
  def aim(x,y)
    setspeed(3,Math.atan2(y-self.y,x-self.x)/Math::PI*180)
  end
end
class Stage2<StageBase
  def init
    STGObj.setmaneger(@mng=STGObjManager.new)
    STGObj.setcommondata(CommonData.new)
    Player.new.setpos(320,400)
    TESTMARISA.call
  end
  def update
    @mng.update
  end
  def render
    @mng.draw
  end
  
  TESTCHILD=proc do |option|
    @image=WHITEBUL
    @frame=0
    param=100
    loop do
      angle=@frame.to_f/30+option[:num]*Math::PI/2
      @x=70*Math::sin(angle)+option[:center_x]
      @y=70*Math::cos(angle)+option[:center_y]
      
      if @frame%3==0 then
        if @frame%200>100 then
          param+=3
        else
          param-=3
        end
        Bullet.new(@x+20*Math::sin(angle*2),@y+20*Math::cos(angle*2)).setspeed(4,param+90).image=TESTIMAGE
        Bullet.new(@x+20*Math::sin(angle*2+Math::PI),@y+20*Math::cos(angle*2+Math::PI)).setspeed(4,param+90-100).image=TESTIMAGE
      end
      @frame+=1
      wait(1)
    end
  end
  
  TESTMARISA = enemy do
    @x=STGSCREEN_W/2
    @y=100
    @image=WHITEBUL
    4.times do |i|
      ShootObj.new :num=>i,:center_x=>@x,:center_y=>@y,&TESTCHILD
    end
  end
  
  BULLETS=[REDBUL,YELLOWBUL,GREENBUL,BLUEBUL,PURPLEBUL]
  MOVE_SAYU=proc{
    flag=true
    loop do
      if @x==MAXX-100 then flag=false
      elsif @x==0+100 then flag=true
      end
      if flag then @x+=1
      else @x-=1
      end
      wait(1)
    end
  }
  MOVE_HANSYA=proc{
    loop do
      @dx=-@dx if @x>MAXX||@x<0
      @dy=-@dy if @y>MAXY||@y<0
      wait(1)
    end
  }
  MOVE_AIM=proc{
    loop do
      setspeed(3,aim)
      wait(1)
    end
  }

  YUKARI=enemy{
    @x=STGSCREEN_W/2
    @y=STGSCREEN_H/2.7
    @image||=WHITEBUL
    shoots=5
    frame=0
    #wait(60)
    #settask(MOVE_SAYU)
    loop do
      angle=(frame+640)**1.5/(60*8)*900
      shoots.times{|i|
        fire(3,angle+(i*360/shoots),TESTIMAGE)
      }
      frame+=1
      wait(1)
    end
  }

  TASK02=task{
    5.times do |i|
      ShootObj.new{
        @x=100;@y=0;setspeed(3,rand(180));@image=WHITEBUL
        settask Act::MOVE_HANSYA
      }
      wait(10)
    end
  }

  MARU9=enemy{
    @x=STGSCREEN_W/2
    @y=150
    @image||=WHITEBUL
    loop do
      100.times do
        fire(rand(4)+1,rand(360),WHITEBUL)
        wait(1)
      end
      wait(30)
      send(:enemybullet){|i|
        i.dx=i.dy=0 unless i.out?
        i.image=WHITEBUL
      }
      wait(60)
      send(:enemybullet){|i|
        i.setspeed(1,rand(360)) unless i.out?
      }
      wait(240)
    end
  }
  QED=enemy{
    @x=320
    @y=100
    #@image||=WHITEBUL
    way=60;span=360.to_f/way
    sleeptime=10
    speed=1.8
    loop do
      @x=rand(STGSCREEN_W-120)+60
      @y=rand(150)+50
      angle = aim - (way - 1) / 2 * span+rand(span);
      way.times {
        fireobj{
          @type=:enemybullet
          @image=TESTIMAGE
          loop do
            if @x>STGSCREEN_W||@x<0 then
              @dx=-@dx
              break
            end
            if @y<0 then
              @dy=-@dy
              break
            end
            wait(1)
          end
        }.setspeed(speed,angle)
        angle += span
      }
      wait sleeptime
      sleeptime-=6 if sleeptime>90
      way+=4 if way<200
      speed+=0.1 if speed<3
    end
  }
end
