module Drawer
  def Drawer.draw(x,y,image,angle=0)
    Window.drawRot( x-image.width/2, y-image.height/2, image, angle )
  end
end
