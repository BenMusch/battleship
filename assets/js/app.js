import 'phoenix_html'
import React from 'react'
import ReactDOM from 'react-dom'

import App from './components/App'

document.addEventListener('DOMContentLoaded', event => {
  let app = document.getElementById('app')
  ReactDOM.render(<App />, app)
})
