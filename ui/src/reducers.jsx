import { combineReducers } from 'redux';
import { reducer as api } from 'redux-json-api';
import reduceReducers from 'reduce-reducers';
import queryString from 'query-string';


const generateRaceAttributes = (state, action) => {
  let newState = state;

  switch (action.type) {
    case 'API_READ':
      const [paramStr] = action.payload.endpoint.split('?');
      const params = queryString.parse(paramStr);
      const includes = params.include ? params.include.split(',') : [];

      const includeMap = state.includeMap || {};
      includes.forEach(includeKey => {
        includeMap[includeKey] = state.api[includeKey].data.reduce((partialMap, includedObj) => {
          const map = partialMap;
          map[includedObj.id] = includedObj;
          return map;
        }, {});

        newState = Object.assign({}, state, { includeMap });
      });
      break;

    default:
      break;
  }

  return newState;
};

const combinedReducer = combineReducers({
  api,
  includeMap: (state) => Object.assign({}, state)
});

// Join all reducers into one.
export default reduceReducers(combinedReducer, generateRaceAttributes);
