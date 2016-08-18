import React from 'react';
import { connect } from 'react-redux';
import { readEndpoint } from 'redux-json-api';


export class RaceSection extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(readEndpoint('attributes'));
    dispatch(readEndpoint('races'));
  }

  render() {
    const {
      props: { attributes, races }
    } = this;

    var raceSectionContent = <div>Loading...</div>;
    if (races && races.length > 0) {
      raceSectionContent = <RaceTable races={races} attributes={attributes}/>;
    }

    return (
      <div className="races">
        <h1>Races</h1>
        {raceSectionContent}
      </div>
    );
  }
}

export class RaceTable extends React.Component {
  render() {
    const {
      props: { attributes, races }
    } = this;
    return (
      <table>
        <tbody>
          <tr>
            <th>Actions</th>
            <th>Image</th>
            <th>Race</th>
            {attributes.map(attribute => <AttributeHeading attribute={attribute} key={attribute.id} />)}
            <th>Height</th>
            <th>Move</th>
          </tr>
          {races.map(race => <RaceRow race={race} attributes={attributes} key={race.name} />)}
        </tbody>
      </table>
    );
  }
}

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
        {attributes.map(attribute => <RaceAttributeLevel attrib_level={attrib_by_id[attribute.id]} key={Math.random()} />)}
        <td>{race.min_height}-{race.max_height}m</td>
        <td>{race.min_move_land}-{race.max_move_land}m</td>
      </tr>
    );
  }
}

export class AttributeHeading extends React.Component {
  render() {
    const {
      props: { attribute }
    } = this;
    return (
      <th>{attribute.name}</th>
    )
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

export const RacePage = connect()(RaceSection);
