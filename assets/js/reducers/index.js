import { combineReducers } from 'redux'

import player from './player'
import board from './board'
import opponent from './opponent'

const rootReducer = combineReducers({player, board, opponent})

export default rootReducer
