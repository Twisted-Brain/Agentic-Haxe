const path = require('path');

module.exports = {
  mode: 'development',
  entry: './www/build/app.js',
  output: {
    path: path.resolve(__dirname, 'www', 'dist'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.js$/,
        enforce: 'pre',
        use: ['source-map-loader'],
      },
    ],
  },
  devServer: {
    static: {
      directory: path.join(__dirname, 'www'),
      publicPath: '/',
    },
    historyApiFallback: true,
    hot: true,
    port: 8080,
  },
};