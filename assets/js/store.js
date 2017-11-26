import { createStore, compose } from 'redux'

import rootReducer from './reducers/index'
import comments from './data/comments'

const defaultState = {
  player: {},
  board: {},
  opponent: {}
}

const store = createStore(rootReducer, defaultState)

export default store
