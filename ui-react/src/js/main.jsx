require("!style!css!../css/styles.css");

import React from 'react';
import { render } from 'react-dom';
import { Router, Route, Link, browserHistory } from 'react-router'

import { App } from './app';
import { Home } from './home';
import { About } from './about';

let root = document.createElement('div');
root.setAttribute('id', 'app');
document.body.appendChild(root);
root = document.getElementById('app');

render((
  <Router history={browserHistory}>
    <Route component={App}>
      <Route path="/" component={Home} />
      <Route path="about" component={About} />
    </Route>
  </Router>
  ), root
);