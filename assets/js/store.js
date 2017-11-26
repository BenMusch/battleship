import { createStore, compose } from 'redux'

import rootReducer from './reducers/index'

const defaultState = {
  player: { joining: true },
  board: {},
  opponent: {}
}

const store = createStore(
  rootReducer,
  defaultState,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
)

export default store
