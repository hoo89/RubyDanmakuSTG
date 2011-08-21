require 'dxruby'
require './scene'
require './teststagescript'
#require './teststagescript2'
Window.height=450*1.2
Window.width=384*1.2
STGSCREEN_W=Window.width
STGSCREEN_H=Window.height
Window.scale=1

CENTER_X=STGSCREEN_W/2
a=Stage1.new

Window.loop do
  a.update
  a.render
end
