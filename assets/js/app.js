import "phoenix_html"
import React from 'react';
import ReactDOM from 'react-dom';

import App from "./components/App";

function start() {
  let root = document.getElementById('root');
  ReactDOM.render(<Game />, root);
}
