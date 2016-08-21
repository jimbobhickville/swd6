import React from 'react';
import { connect } from 'react-redux';
import { IndexLink, Link } from 'react-router';
import { setEndpointHost, setEndpointPath } from 'redux-json-api';

export class AppWrapper extends React.Component {
  componentWillMount() {
    const { dispatch } = this.props;
    dispatch(setEndpointHost('http://localhost:8080'));
    dispatch(setEndpointPath('/api'));
  }
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

export const App = connect()(AppWrapper);
