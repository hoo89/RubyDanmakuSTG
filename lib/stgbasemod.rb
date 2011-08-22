module BaseAct
  def setpos(x,y)
    self.x=x
    self.y=y
    self
  end
  def setspeed(speed,angle)
    self.dx=speed*Math.cos(angle/180.0*Math::PI)
    self.dy=speed*Math.sin(angle/180.0*Math::PI)
    self
  end
  def setimage(image)
    self.image=image
    self
  end
  def out?
    self.x<0||self.y<0||self.x>STGSCREEN_W||self.y>STGSCREEN_H
  end
  def getangle
    return nil if self.dx==0.0&&self.dy==0.0
    Math.atan2(self.dy,self.dx)/Math::PI*180+90
  end
  def outofscreen?
    self.x > STGSCREEN_W+30||self.x < -30||self.y > STGSCREEN_H+30||self.y < -30
  end
end