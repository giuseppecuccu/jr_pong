
module Constants
  module Graphics
    GRAPHICS_PATH = 'graphics'
    BG_IMG     = File.join(GRAPHICS_PATH, 'bg.png')
    BALL_IMG   = File.join(GRAPHICS_PATH, 'ball.png')
    PADDLE_IMG = File.join(GRAPHICS_PATH, 'paddle.png')
  end

  module Dynamics
    GAME_SPEED = 0.3
    PADDLE_HEIGHT = 400
  end

  module Misc
    # Starting `::` denotes root module
    FONT_SIZE = 8
    MESSAGE_HEIGHT = 30
  end

  module Ball
    RAD = ::Math::PI / 180
  end
end
