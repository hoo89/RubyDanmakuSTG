require 'dxruby'
require './teststagescript'
#require './teststagescript2'
Window.height=450*1.2
Window.width=384*1.2
STGSCREEN_W=Window.width
STGSCREEN_H=Window.height
Window.scale=1

CENTER_X=STGSCREEN_W/2

Director.run(TestStage2.new)