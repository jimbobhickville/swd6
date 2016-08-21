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
      props: { races, attributes, race_attributes }
    } = this;

    const raceAttributeMap = race_attributes.data.reduce((partialMap, raceAttribute) => {
      const map = partialMap;
      if (!map[raceAttribute.attributes.race_id]) {
        map[raceAttribute.attributes.race_id] = {};
      }
      map[raceAttribute.attributes.race_id][raceAttribute.attributes.attribute_id] = raceAttribute;
      return map;
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

RaceTable.defaultProps = { races: { data: [] }, attributes: { data: [] }, race_attributes: { data: [] } };

export class RaceRow extends React.Component {
  render() {
    const {
      props: { race, attributeOrder, raceAttributes }
    } = this;
    var raceAttributeColumns;
    if (raceAttributes[race.id]) {
      raceAttributeColumns = attributeOrder.map(attributeId => <RaceAttributeLevel raceAttribute={raceAttributes[race.id][attributeId]} key={attributeId} />);
    } else {
      raceAttributeColumns = attributeOrder.map(attributeId => <td key={attributeId} />);
    }

    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{/* #TODO: add thumbnail component */}</td>
        <td>{race.attributes.name}</td>
        {raceAttributeColumns}
        <td>{race.attributes.min_height}-{race.attributes.max_height}m</td>
        <td>{race.attributes.min_move_land}-{race.attributes.max_move_land}m</td>
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
        <Level level={raceAttribute.attributes.min_level} />
        /
        <Level level={raceAttribute.attributes.max_level} />
      </td>
    );
  }
}

export const RacePage = jsonApiConnect(RaceTable);
