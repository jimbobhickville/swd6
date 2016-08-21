import React from 'react';

export class Level extends React.Component {
  render() {
    var dice;
    var pips;

    const {
      props: { level }
    } = this;

    if (!level) {
      return (<level>0D</level>);
    }

    [dice, pips] = level.toString().split('.');

    if (parseInt(pips, 10) > 0) {
      return (<level>{`${dice}D+${pips}`}</level>);
    }

    return (<level>{`${dice}D`}</level>);
  }
}
