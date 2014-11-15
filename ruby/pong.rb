require 'constants'
require 'elements'

# This class works by calling `init` upon construction, then `update`
# and `render` at each timestep.
#
# The class is monolitic rather than OO for the sake of lighter reading:
# all the game is here, but for the launcher and some constants
#
class SimplePong < BasicGame
  # These modules are defined in ruby/constants.rb
  include Constants::Graphics
  include Constants::Dynamics
  include Constants::Misc

  attr_reader :objs, :msg
  attr_accessor :game_speed

  # Main game initialization
  #
  def init container
    self.game_speed = GAME_SPEED
    # Array of objects to be drawn in correct order
    self.objs = []
    # Background is a fullscreen png
    objs << (@bg     = Elements::Background.new  BG_IMG)
    # Paddle moves along a fixed y, and x corresponds to its left corner
    objs << (@paddle = Elements::Paddle.new  PADDLE_IMG, [200, PADDLE_HEIGHT],
                          container.width)
    # Ball has a x and y coordinate, plus angle of motion direction
    objs << (@ball   = Elements::Ball.new  BALL_IMG, [200, 200, nil],
                          [container.width, container.height], @paddle)
    # Playing instructions are displayed on bottom of the screen
    self.msg = Elements::Message.new 'Arrows to control, ESC to quit',
             FONT_SIZE, container.height - MESSAGE_HEIGHT, @ball
  end

  # Main rendering function
  #
  def render container, graphics
    objs.each &:draw
    msg.draw  graphics
  end

  def grab_input container
    input = container.get_input
    container.exit if input.is(:esc)    
    input
  end

  def reset
    objs.each(&:reset)
    self.game_speed = GAME_SPEED
  end

  def update *args
    objs.each do |obj| 
      obj.update(*args)
    end
  end

  # Main updating function
  #
  def update container, delta
    self.game_speed += GAME_SPEED_INCREMENT # come get some!
    input = grab_input  container
    update  container, delta, input, game_speed
    reset if @ball.fallen?
  end
end
