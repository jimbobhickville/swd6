import React from 'react';
import { readEndpoint } from 'redux-json-api';

import { jsonApiConnect } from './jsonapi';
import { Level } from './util';

export class RaceTable extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes?sort=name'));
    dispatch(readEndpoint('races?sort=name&include=attributes'));
  }

  render() {
    const {
      props: { races, attributes }
    } = this;
    console.log(this.props);
    const raceAttributeMap = this.props['race-attributes'].data.reduce((partialMap, raceAttribute) => {
      partialMap[raceAttribute.attributes['race-id']][raceAttribute.attributes['attribute-id']] = raceAttribute;
    }, {});
    const attributeOrder = attributes.data.map(attribute => attribute.id);
    return (
      <div className="races">
        <h1>Races</h1>
        <table>
          <tbody>
            <tr>
              <th>Actions</th>
              <th>Image</th>
              <th>Race</th>
              {attributes.data.map(attribute => <th key={attribute.id}>{attribute.attributes.name}</th>)}
              <th>Height</th>
              <th>Move</th>
            </tr>
          {races.data.map(race => <RaceRow race={race} attributeOrder={attributeOrder} raceAttributes={raceAttributeMap} key={race.id} />)}
          </tbody>
        </table>
      </div>
    );
  }
}

RaceTable.defaultProps = { races: { data: [] }, attributes: { data: [] }, 'race-attributes': { data: [] } };

export class RaceRow extends React.Component {
  render() {
    const {
      props: { race, attributeOrder, raceAttributes }
    } = this;
    const raceAttributeMap = race.relationships.attributes.data.reduce((partialMap, attribute) => {
      partialMap[attribute.id] = raceAttributes[race.id][attribute.id];
    }, {});

    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{/* #TODO: add thumbnail component */}</td>
        <td>{race.attributes.name}</td>
        {attributeOrder.map(attributeId => <RaceAttributeLevel raceAttribute={raceAttributeMap[attributeId]} key={attributeId} />)}
        <td>{race.attributes['min-height']}-{race.attributes['max-height']}m</td>
        <td>{race.attributes['min-move-land']}-{race.attributes['max-move-land']}m</td>
      </tr>
    );
  }
}

export class RaceAttributeLevel extends React.Component {
  render() {
    const {
      props: { raceAttribute }
    } = this;
    return (
      <td>
        <Level level={raceAttribute.attributes['min-level']} key={raceAttribute.attributes['min-level']} />
        /
        <Level level={raceAttribute.attributes['max_level']} key={raceAttribute.attributes['max_level']} />
      </td>
    );
  }
}

export const RacePage = jsonApiConnect(RaceTable);
