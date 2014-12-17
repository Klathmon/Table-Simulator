module.exports = {
  plugins: {
    "web-component-tester-istanbul": {

      dir: "./coverage",

      reporters: ["text-summary", "lcov"],

      include: [
      "/**/*.js",
      ],

      exclude: [
      "/bower_components/**/*.js",
      "/testing/*.js",
      "/**/tests/*.js"
      ]

    }
  }
};
