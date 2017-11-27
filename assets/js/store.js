import { createStore, compose } from 'redux'

import rootReducer from './reducers/index'
import { NOT_GUESSED } from './battleship/constants'

const defaultState = {
  player: { joining: true },
  board: {
    grid: Array(10).fill(Array(10).fill(NOT_GUESSED)),
    unplaced_ships: [5, 4, 3, 3, 2],
    placed_ships: []
  },
  opponent: {
    grid: Array(10).fill(Array(10).fill(NOT_GUESSED)),
    unplaced_ships: [5, 4, 3, 3, 2],
    id: null
  }
}

const store = createStore(
  rootReducer,
  defaultState,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
)

export default store
