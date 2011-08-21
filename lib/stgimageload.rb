class Image
  def haveangle
    @hasangle=true
    self
  end
  def hasangle?
    false||@hasangle
  end
end

REDBUL||=Image.new(5,5,[255,0,0])
YELLOWBUL||=Image.new(5,5,[255,255,0])
GREENBUL||=Image.new(5,5,[0,255,0])
BLUEBUL||=Image.new(5,5,[0,0,255])
PURPLEBUL||=Image.new(5,5,[255,0,255])
#WHITEENE=FillSquare.new(0, 0, 10, 10, :color => [255, 255, 255])

WHITEBUL||=Image.new(5,5,[255,255,255])
TESTIMAGE||=Image.load( "kShot.png",84,63,11,18).haveangle
