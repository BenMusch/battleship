import { combineReducers } from 'redux'

import game from './game'
import board from './board'
import opponent from './opponent'

const rootReducer = combineReducers({game, board, opponent})

export default rootReducer
