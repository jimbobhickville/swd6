import React from 'react';

export class Home extends React.Component {
  render() {
    return (
      <div className="home">
        <h1>Homepage</h1>
        <p>This is the best god damned website ever created!!!</p>
        <img src={"http://i1180.photobucket.com/albums/x413/pappawookee/guitarwookie.jpg"} />
        {this.props.children}
      </div>
    );
  }
}
