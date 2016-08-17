require("!style!css!../css/styles.css");

import React from 'react';
import { render } from 'react-dom';
import { Router, Route, Link, browserHistory } from 'react-router'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import { setEndpointHost, setEndpointPath } from 'redux-json-api'

import { App } from './app';
import { Home } from './home';
import { About } from './about';
import { RaceConnector } from './races';

let store = createStore(App);

/* TODO: configurable API endpoint */
setEndpointHost('http://localhost:8080');
setEndpointPath('/api');

let root = document.createElement('div');
root.setAttribute('id', 'app');
document.body.appendChild(root);
root = document.getElementById('app');

render((
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route component={App}>
        <Route path="/" component={Home} />
        <Route path="races" component={RaceConnector} />
        <Route path="about" component={About} />
      </Route>
    </Router>
  </Provider>
  ), root
);