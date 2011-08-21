require 'dxruby'

module Scene
  class Exit
  end

  class Base
    attr_accessor :next_scene_class,:next_option
    attr_reader :frame_counter

    def initialize(*option)
      @frame_counter = 0
      @next_scene_class=nil
      init(*option)
    end
    
    def __update
      @frame_counter += 1
      update
    end
    #private :__update

    def init(*option)
    end

    def quit
    end

    def update
    end

    def render
    end
    
    def next_scene(scene_class,option)
      @next_scene_class=scene_class
      @next_option=option
    end
  end
  
  @default_step=1
  @default_fps=60
  def self.main_loop(scene_class, *option)
    step=@default_step
    scene=scene_class.new(*option)
    
    Window.loop do
      step.times do
        scene.__update
        break if scene.next_scene_class
      end
      scene.render
      if scene.next_scene_class
        scene.quit
        break if Exit == scene.next_scene
        scene = scene.next_scene.new(scene.next_option)
      end
    end
  end
end
