import { combineReducers } from 'redux';
import { reducer as api } from 'redux-json-api';
import reduceReducers from 'reduce-reducers';

const generateRaceAttributes = (state, action) => {
  let newState = state;

  switch (action.type) {
    case 'API_READ':
      if (action.payload.endpoint === 'races?sort=name&include=attributes') {
        const raceAttributeMap = state.api.race_attributes.data.reduce((partialMap, raceAttribute) => {
          const map = partialMap;
          if (!map[raceAttribute.attributes.race_id]) {
            map[raceAttribute.attributes.race_id] = {};
          }
          map[raceAttribute.attributes.race_id][raceAttribute.attributes.attribute_id] = raceAttribute;
          return map;
        }, {});

        newState = Object.assign({}, state, { raceAttributeMap });
      }
      break;

    default:
      break;
  }

  return newState;
};

const combinedReducer = combineReducers({
  api,
  raceAttributeMap: (state) => Object.assign({}, state)
});

// Join all reducers into one.
export default reduceReducers(combinedReducer, generateRaceAttributes);
