import { connect } from 'react-redux';


export const jsonApiConnect = function jsonApiConnect(componentClass) {
  function mapStateToProps(state) {
    var myProps = {};
    Object.keys(componentClass.defaultProps).forEach((key) => {
      if (state.api && state.api[key]) {
        myProps[key] = state.api[key];
      } else {
        myProps[key] = componentClass.defaultProps[key];
      }
    });
    return myProps;
  }
  return connect(mapStateToProps)(componentClass);
};
