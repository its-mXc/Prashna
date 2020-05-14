const { environment } = require('@rails/webpacker')

const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({

$: 'jquery',

jQuery: 'jquery',

Popper: ['popper.js', 'default']


}))


const aliasConfig = {
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);

module.exports = environment
