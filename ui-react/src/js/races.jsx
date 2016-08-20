import React from 'react';
import { readEndpoint } from 'redux-json-api';

import { jsonApiConnect } from './jsonapi'
import { Level } from './util'

export class RaceTable extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes?sort=name'));
    dispatch(readEndpoint('races?sort=name&include=attributes'));
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
      props: { race }
    } = this;
    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{/* #TODO: add thumbnail component */}</td>
        <td>{race.attributes.name}</td>
        {race.relationships.attributes.data.map(attribute => <RaceAttributeLevel attribute_level={attribute} key={attribute.id} />)}
        <td>{race.attributes['min-height']}-{race.attributes['max-height']}m</td>
        <td>{race.attributes['min-move-land']}-{race.attributes['max-move-land']}m</td>
      </tr>
    );
  }
}

export class RaceAttributeLevel extends React.Component {
  render() {
    const {
      props: { attribute_level }
    } = this;
    return (
      <td>
        <Level level={attribute_level.attributes.min_level} key={attribute_level.attributes.min_level} />
        /
        <Level level={attribute_level.attributes.max_level} key={attribute_level.attributes.max_level} />
      </td>
    )
  }
}

export const RacePage = jsonApiConnect(RaceTable);
