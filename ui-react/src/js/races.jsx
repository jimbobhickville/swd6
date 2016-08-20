import React from 'react';
import { readEndpoint } from 'redux-json-api';

import { jsonApiConnect } from './jsonapi'

export class RaceTable extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes?sort=name'));
    dispatch(readEndpoint('races?sort=name'));
  }

  render() {
    return (
      <div className="races">
        <h1>Races</h1>
        <table>
          <tbody>
          <tr>
            <th>Actions</th>
            <th>Image</th>
            <th>Race</th>
            {this.props.attributes.map(attribute => <th key={attribute.id}>{attribute.attributes.name}</th>)}
            <th>Height</th>
            <th>Move</th>
          </tr>
          {this.props.races.map(race => <RaceRow race={race} attributes={this.props.attributes} key={race.id} />)}
          </tbody>
        </table>
      </div>
    );
  }
}
RaceTable.defaultProps = {races: [], attributes: []};

export class RaceRow extends React.Component {
  render() {
    const {
      props: { attributes, race }
    } = this;
    var attribLevel = {min_dice: 2, max_dice: 4};
    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{/* #TODO: add thumbnail component */}</td>
        <td>{race.attributes.name}</td>
        {attributes.map(attribute => <RaceAttributeLevel attrib_level={attribLevel} key={attribute.id} />)}
        <td>{race.attributes['min-height']}-{race.attributes['max-height']}m</td>
        <td>{race.attributes['min-move-land']}-{race.attributes['max-move-land']}m</td>
      </tr>
    );
  }
}

export class RaceAttributeLevel extends React.Component {
  render() {
    const {
      props: { attrib_level }
    } = this;
    return (
      <td>{attrib_level.min_dice}D/{attrib_level.max_dice}D</td>
    )
  }
}

export const RacePage = jsonApiConnect(RaceTable);
