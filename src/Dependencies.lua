-- importing the push and class libraries

push = require 'lib/push'
Class = require 'lib/class'

-- for global constants
require 'src/constants'

-- for paddles and balls
require 'src/Paddle'
require 'src/Ball'

-- for StateMachines and different states
require 'src/StateMachine'

-- for different sizes of paddles, balls, bricks etc
require 'src/Util'

require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/StartState'