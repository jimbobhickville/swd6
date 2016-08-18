import React from 'react';
import { connect } from 'react-redux';
import { readEndpoint } from 'redux-json-api';


export class RaceTable extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes'));
    dispatch(readEndpoint('races'));
  }

  render() {
    const {
      props: { attributes, races }
    } = this;

    return (
      <div className="races">
        <h1>Races</h1>
        <table>
          <tbody>
          <tr>
            <th>Actions</th>
            <th>Image</th>
            <th>Race</th>
            {attributes.map(attribute => <th>{attribute.name}</th>)}
            <th>Height</th>
            <th>Move</th>
          </tr>
          {races.map(race => <RaceRow race={race} attributes={attributes} key={race.id} />)}
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
    console.log(this.props);
    var attrib_by_id = race.race_attrib_levels.reduce(attrib_level => ((hash, next) => hash[next.attrib_id] = next), {});
    return (
      <tr>
        <td>{/* #TODO: add edit/delete links */}</td>
        <td>{/* #TODO: add thumbnail component */}</td>
        <td>{race.name}</td>
        {attributes.map(attribute => <RaceAttributeLevel attrib_level={attrib_by_id[attribute.id]} key={attribute.id} />)}
        <td>{race.min_height}-{race.max_height}m</td>
        <td>{race.min_move_land}-{race.max_move_land}m</td>
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
      <th>{attrib_level.min_dice}D/{attrib_level.max_dice}D</th>
    )
  }
}

export const RacePage = connect()(RaceTable);
