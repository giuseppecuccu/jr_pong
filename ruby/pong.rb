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

  # Main game initialization
  #
  def init container
    # Array of objects to be drawn in correct order
    @objs = []
    # Background is a fullscreen png
    @objs << (@bg     = Elements::Background.new  BG_IMG)
    # Ball has a x and y coordinate, plus angle of motion direction
    @objs << (@ball   = Elements::Ball.new  BALL_IMG, [200, 200, 45],
              [container.width, container.height])
    # Paddle has fixed y, and x corresponds to the left corner
    @objs << (@paddle = Elements::Paddle.new  PADDLE_IMG, [200, PADDLE_HEIGHT],
              container.width)

    reset
  end

  def reset
    @objs.each &:reset
  end

  # Main rendering function
  #
  def render container, graphics
    # Draw objects
    @objs.each &:draw
    # Draw message
    text = 'Arrows to control, ESC to quit'
    place = container.height - MESSAGE_HEIGHT
    graphics.draw_string  text, FONT_SIZE, place
  end

  def grab_input container
    input = container.get_input
    container.exit if input.is(:esc)    
    input
  end

  def ball_touches_paddle?
    @ball.x >= @paddle.x && 
    @ball.x <= (@paddle.x + @paddle.width) && 
    @ball.y.round >= (PADDLE_HEIGHT - @ball.height)    
  end

  def ball_paddle_interaction
    if ball_touches_paddle?
      @ball.rotate
    end
  end

  # Main updating function
  #
  def update container, delta
    input = grab_input  container
    @paddle.update  container, delta, input, GAME_SPEED
    @ball.update  container, delta, GAME_SPEED
    ball_paddle_interaction
    reset if @ball.fallen?
  end
end
