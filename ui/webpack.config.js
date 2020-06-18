const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');
var LodashModuleReplacementPlugin = require('lodash-webpack-plugin');
// const HtmlWebpackPlugin = require("html-webpack-plugin");
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
const path = require('path');

module.exports = {
  // stats: 'verbose',
  // target: 'node',
  mode: 'production',
  entry: path.resolve(__dirname, 'index.js'),
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js'
  },
  resolve: {
    alias: {
      app: path.resolve('./app'),
    },
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ['ng-annotate-loader'],
      },
      {
        test: /\.coffee$/,
        use: [
          {
            loader: 'babel-loader',
            'options': {
              'plugins': ['lodash'],
              'presets': [['env', { 'modules': false, 'targets': { 'node': 4 } }]]
            }
        },
        { loader: 'ng-annotate-loader' },
         { loader: 'coffee-loader', options: { sourceMap: true, filename: 'bundle.map.js', header: false } }]
      },
      {
        test: /\.html$/,
        exclude: /node_modules|index.html|404.html/,
        loader: ['raw-loader']
        // use: [
        //   { loader:'ngtemplate-loader?relativeTo=' + (path.resolve(__dirname, './')) },
        //   { loader: 'html-loader' }
        // ]
      },
      {
        test: /\.s[ac]ss$/i,
        exclude: /node_modules/,
        use: ['style-loader', 'css-loader','sass-loader'],
      },
    ],
  },
  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin({
      test: /\.js(\?.*)?$/i,
    })],
  },
  plugins: [
    // new HtmlWebpackPlugin({
    //   template: path.resolve(__dirname, "app", "index.html")
    // }),
    new LodashModuleReplacementPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new BundleAnalyzerPlugin(),
  ]
};
