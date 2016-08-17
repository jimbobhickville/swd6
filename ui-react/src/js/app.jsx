import React from 'react';

import { IndexLink, Link } from 'react-router';

export class App extends React.Component {
  render() {
    return (
      <div className="swd6">
        <nav>
          <IndexLink to="/" activeClassName="active">Home</IndexLink>
          <Link to="/races" activeClassName="active">Races</Link>
          <Link to="/planets" activeClassName="active">Planets</Link>
          <Link to="/about" activeClassName="active">About</Link>
        </nav>
        {this.props.children}
      </div>
    );
  }
}