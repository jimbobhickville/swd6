import { connect } from 'react-redux';


export const jsonApiConnect = function(componentClass) {
  function mapStateToProps(state) {
    var myProps = {};
    for (var key in componentClass.defaultProps){
      if (state.api && state.api[key]) {
        myProps[key] = state.api[key].data;
      } else {
        myProps[key] = componentClass.defaultProps[key];
      }
    }
    return myProps;
  }
  return connect(mapStateToProps)(componentClass);
};
