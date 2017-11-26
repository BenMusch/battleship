import 'phoenix_html'
import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import App from './components/App'
import store from './store'

const toRender = (
  <Provider store={store}>
    <App />
  </Provider>
)

document.addEventListener('DOMContentLoaded', event => {
  let app = document.getElementById('app')
  ReactDOM.render(toRender, app)
})
