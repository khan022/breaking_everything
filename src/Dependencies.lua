-- importing the push and class libraries

push = require 'lib/push'
Class = require 'lib/class'

-- for global constants
require 'src/constants'
require 'src/classes/LevelMaker'

-- for paddles and balls and bricks
require 'src/classes/Paddle'
require 'src/classes/Ball'
require 'src/classes/Brick'

-- for StateMachines and different states
require 'src/StateMachine'

-- for different sizes of paddles, balls, bricks etc
require 'src/Util'

require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/ServeState'
require 'src/states/GameOverState'
require 'src/states/VictoryState'