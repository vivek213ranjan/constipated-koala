const { environment } = require('@rails/webpacker')

environment.module.push({
  rules: [
    {
      test: /\.css$/,
      use: ['style-loader', 'postcss-loader'],
    },
  ],
});

module.exports = environment
