const { environment } = require('@rails/webpacker')
const svelte = require('./loaders/svelte')

const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.config.resolve.alias = { 'vue$': 'vue/dist/vue.esm.js' }

const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
)
environment.loaders.prepend('svelte', svelte)
module.exports = environment
