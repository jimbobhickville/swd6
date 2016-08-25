const path = require('path');

module.exports = {
  entry: './src/js/main.jsx',
  output: {
    path: 'dist/',
    filename: 'bundle.js'
  },
  resolve: {
    extensions: ['', '.jsx', '.js']
  },
  module: {
    loaders: [
      {
        test: [
          path.join(__dirname, 'src/js')
        ],
        loader: 'babel'
      },
      {
        test: /\.+(js|jsx)$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel',
        query: {
          presets: ['es2015', 'react']
        }
      },
      { test: /\.css$/, loader: 'style!css' }
    ]
  }
};