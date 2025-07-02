/**
 * Config plugin for expo-portmone
 * This makes the plugin available to be used in app.config.js/app.json
 * by including "expo-portmone" in the plugins array
 */
const { withPlugins } = require('@expo/config-plugins')
const withPortmoneAndroidDeployment = require('./lib/commonjs/plugin/src/withPortmoneAndroidDeployment')
const withPortmoneIosDeployment = require('./lib/commonjs/plugin/src/withPortmoneIosDeployment')

module.exports = (config) =>
  withPlugins(config, [
    withPortmoneAndroidDeployment,
    withPortmoneIosDeployment,
  ])
