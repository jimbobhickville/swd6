import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { Router, Route, browserHistory } from 'react-router';
import { createStore, applyMiddleware } from 'redux';
import createLogger from 'redux-logger';
import thunkMiddleware from 'redux-thunk';

import './index.css';

import reducer from './reducers';
import { About } from './about';
import { App } from './app';
import { Home } from './home';
import { RacePage } from './races';

const loggerMiddleware = createLogger();

let store = createStore(reducer, applyMiddleware(
  thunkMiddleware, // lets us dispatch() functions
  loggerMiddleware // neat middleware that logs actions
));

let root = document.createElement('div');
root.setAttribute('id', 'app');
document.body.appendChild(root);
root = document.getElementById('app');

render((
  <Provider store={store}>
    <Router history={browserHistory}>
      <Route component={App}>
        <Route path="/" component={Home} />
        <Route path="races" component={RacePage} />
        <Route path="about" component={About} />
      </Route>
    </Router>
  </Provider>
  ), document.getElementById('root')
);
