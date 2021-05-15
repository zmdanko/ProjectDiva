const CompressionWebpackPlugin = require('compression-webpack-plugin')

module.exports = {
    devServer: {
        port: 11001,
        disableHostCheck: true
    },

    transpileDependencies: [
        'vuetify'
    ],

}
