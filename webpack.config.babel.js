import 'babel-register';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import ImageminWebpackPlugin from 'imagemin-webpack-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import { DefinePlugin } from 'webpack';
import { resolve } from 'path';
import getContext from './config';
import * as nunjucksFilters from './views/filters';

module.exports = async (env = 'development') => ({
  entry: {
    bundle: ['./client/index.js'],
  },
  resolve: {
    modules: ['node_modules', 'bower_components'],
  },
  output: {
    filename: env === 'production' ? '[name].[hash].js' : '[name].js',
    path: resolve(__dirname, 'dist'),
  },
  module: {
    rules: [
      {
        test: /\.(txt|csv|tsv|xml)$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'raw-loader',
        },
      },
      {
        test: /\.ya?ml$/,
        exclude: /(node_modules|bower_components)/,
        type: 'json',
        use: {
          loader: 'yaml-loader',
        },
      },
      {
        test: /\.js$/,
        exclude: /(node_modules(?!\/inkjs)|bower_components)/,
        use: {
          loader: 'babel-loader',
        },
      },
      {
        test: /\.(png|jpe?g|gif)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'images/',
              name: '[name]--[hash].[ext]',
            },
          },
        ],
      },
      {
        test: /\.(woff2?|ttf|eot)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              outputPath: 'fonts/',
              name: '[name]--[hash].[ext]',
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name]--[hash].[ext]',
            },
          },
          {
            loader: 'extract-loader',
            options: {
              publicPath: "",
            },
          },
          { loader: 'css-loader', options: { sourceMap: true, url: true } },
          { loader: 'postcss-loader', options: { sourceMap: true } },
        ],
      },
      {
        test: /\.(html|njk)$/,
        use: [
          {
            loader: 'html-loader',
            options: {
              attrs: ['img:src', 'link:href'],
              root: resolve(__dirname, 'client'),
            },
          },
          {
            loader: 'nunjucks-html-loader',
            options: {
              searchPaths: [resolve(__dirname, 'views')],
              filters: nunjucksFilters,
              context: await getContext(env),
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        resolve: {
          extensions: ['.scss', '.sass'],
        },
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              hmr: env === 'development',
            },
          },
          { loader: 'css-loader', options: { sourceMap: true } },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true,
              includePaths: ['node_modules', 'node_modules/@financial-times', 'bower_components'],
            },
          },
        ],
      },
    ],
  },
  devServer: {
    hot: false, // Needed for live-reloading Nunjucks templates.
    allowedHosts: ['.ngrok.io', 'local.ft.com', 'bs-local.com'],
  },
  devtool: env === 'development' ? 'inline-source-map' : 'source-map',
  plugins: [
    new DefinePlugin({
      'window.ENV': JSON.stringify(env),
    }),
    // new HotModuleReplacementPlugin(), // Re-enable if devServer.hot is set to true
    new MiniCssExtractPlugin({
      filename: env === 'development' ? '[name].css' : '[name].[contenthash].css',
    }),
    new HtmlWebpackPlugin({
      template: 'client/index.html',
    }),
    env === 'production'
      ? new ImageminWebpackPlugin({ test: /\.(jpe?g|png|gif|svg)$/i })
      : undefined,
  ].filter(i => i),
});
