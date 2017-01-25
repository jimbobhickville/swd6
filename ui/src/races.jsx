import React from 'react';
import { connect } from 'react-redux';
import { readEndpoint } from 'redux-json-api';

import { Level } from './util';

export class RaceTable extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes?sort=display_order'));
    dispatch(readEndpoint('races?sort=name&include=race_attributes,images&fields[races]=name,min_height,max_height,min_move_land,max_move_land,race_attributes,images'));
  }

  render() {
    var {
      props: { races, attributes, includeMap }
    } = this;

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
          {races.data.map(race => <RaceRow race={race} attributeOrder={attributeOrder} includeMap={includeMap} key={race.id} />)}
          </tbody>
        </table>
      </div>
    );
  }
}

RaceTable.defaultProps = { races: { data: [] }, attributes: { data: [] }, includeMap: { race_attributes: {} } };

export class RaceRow extends React.Component {
  render() {
    const {
      props: { race, attributeOrder, includeMap }
    } = this;

    var raceAttributeMap = {};
    race.relationships.race_attributes.data.map(relationship => {
      const raceAttribute = includeMap.race_attributes[relationship.id];
      if (raceAttribute) {
        raceAttributeMap[raceAttribute.attributes.attribute_id] = raceAttribute;
      }
    });

    var thumbnail = "";
    if (race.relationships.images.data.length > 0) {
      const image = includeMap.images[race.relationships.images.data[0].id];
      thumbnail = <img src={`http://swd6.gnhill.net/uploads/images/${image.attributes.dir}/thumbs/${image.attributes.name}`} />
    }

    var raceAttributeColumns;
    if (Object.keys(raceAttributeMap).length > 0) {
      raceAttributeColumns = attributeOrder.map(attributeId => <RaceAttributeLevel raceAttribute={raceAttributeMap[attributeId]} key={attributeId} />);
    } else {
      raceAttributeColumns = attributeOrder.map(attributeId => <td key={attributeId} />);
    }

    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{thumbnail}</td>
        <td>{race.attributes.name}</td>
        {raceAttributeColumns}
        <td>{race.attributes.min_height.toFixed(1)}-{race.attributes.max_height.toFixed(1)}m</td>
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

const mapStateToProps = (state) => ({
  races: state.api.races,
  attributes: state.api.attributes,
  race_attributes: state.api.race_attributes,
  includeMap: state.includeMap
});

export const RacePage = connect(mapStateToProps)(RaceTable);
