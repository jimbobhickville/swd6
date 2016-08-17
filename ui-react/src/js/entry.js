require("!style!css!../css/styles.css");
document.write('Hello people of the internets!');
document.write(require('./content'));

class Taco {
  constructor() {
    this.type = 'beef';
  }
  kind() {
    return this.type;
  }
}

var taco = new Taco();
document.write(taco.kind());

var React = require('react');
var ReactDOM = require('react-dom');
ReactDOM.render(
  <h1>Hello, world!</h1>,
  document.getElementById('root')
);