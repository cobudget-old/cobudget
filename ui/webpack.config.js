const webpack = require("webpack");
const TerserPlugin = require("terser-webpack-plugin");
const LodashModuleReplacementPlugin = require("lodash-webpack-plugin");
// const HtmlWebpackPlugin = require("html-webpack-plugin");
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;
const path = require("path");

module.exports = {
  // stats: 'verbose',
  // target: 'node',
  mode: "production",
  entry: path.resolve(__dirname, "index.js"),
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "[name].[contenthash].js",
  },
  resolve: {
    extensions: [".tsx", ".ts"],
    alias: {
      app: path.resolve("./app"),
    },
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [{ loader: "ng-annotate-loader" }],
      },
      {
        test: /\.tsx?$/,
        exclude: /node_modules/,
        use: [
          {
            loader: "babel-loader",
            options: {
              plugins: ["lodash"],
              presets: [["env", { modules: false, targets: { node: 4 } }]],
            },
          },
          { loader: "ts-loader" },
        ],
      },
      {
        test: /\.coffee$/,
        exclude: /node_modules/,
        use: [
          { loader: "ng-annotate-loader" },
          {
            loader: "coffee-loader",
            options: {
              sourceMap: true,
              filename: "bundle.map.js",
              header: false,
            },
          },
        ],
      },
      {
        test: /\.html$/,
        exclude: /node_modules|index.html|404.html/,
        loader: ["raw-loader"],
      },
      {
        test: /\.s[ac]ss$/i,
        exclude: /node_modules/,
        use: ["style-loader", "css-loader", "sass-loader"],
      },
    ],
  },
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        test: /\.js(\?.*)?$/i,
      }),
    ],
    runtimeChunk: false,
    // splitChunks: {
    //   vendor: {
    //     test: /[\/]node_modules[\/]/,
    //     priority: 1,
    //     enforce: true,
    //     chunks: (chunk) => chunk.name === frameElement,
    //     name: vendor,
    //   },
    // },
  },
  plugins: [
    // new HtmlWebpackPlugin({
    //   template: path.resolve(__dirname, "app", "index.html")
    // }),
    new LodashModuleReplacementPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new BundleAnalyzerPlugin(),
  ],
};
