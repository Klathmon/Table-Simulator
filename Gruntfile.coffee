RELEASE_DIR = 'release'
BUILD_DIR = 'build'
TEMP_DIR = '.tmp'
APP_DIR = 'app'

mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)
  return

module.exports = (grunt) ->

  require('time-grunt') grunt
  require('jit-grunt') grunt,
    useminPrepare: 'grunt-usemin'
    gitpush: 'grunt-git'
    'wct-test': 'web-component-tester'

  grunt.initConfig

    copy:
      html:
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'app.html'
            'elements/**/*.html'
            'testing/**/*.html'
          ]
          dest: BUILD_DIR
          ext: '.html'
        ]
      bower:
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'bower_components/**'
          ]
          dest: BUILD_DIR
        ]
      ghpages:
        files: [
          expand: true
          cwd: 'ghpages'
          src: [
            '**'
          ]
          dest: RELEASE_DIR + '/'
        ]
      fixusemin:
        files: [
          expand: true
          cwd: TEMP_DIR + '/concat/'
          src: '**'
          dest: BUILD_DIR
        ]

    dom_munger:
      coffee2js:
        options:
          callback: ($)->
            $("script[src!='']").each ->
              $(this).attr('src', $(this).attr('src').replace('.coffee', '.js'))
              return
            return
        src: [
          BUILD_DIR + '/**/*.html'
          '!' + BUILD_DIR + '/bower_components/**/*.html'
        ]
      sass2css:
        options:
          callback: ($)->
            $("link[rel='stylesheet']").each ->
              href = $(this).attr('href')
              href = href.replace('.sass', '.css')
              href = href.replace('.scss', '.css')
              $(this).attr('href', href)
              return
            return
        src: [
          BUILD_DIR + '/**/*.html'
          '!' + BUILD_DIR + '/bower_components/**/*.html'
        ]

    sass:
      options:
        cacheLocation: TEMP_DIR
        loadPath: require('node-bourbon').with(APP_DIR + '/styles/partials')

      dev:
        options:
          sourcemap: 'file'
          style: 'expanded'
          update: true
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'styles/**/*.{sass,scss}'
            'elements/**/*.{scss,sass}'
            'testing/**/*.{scss,sass}'
          ]
          dest: BUILD_DIR
          ext: '.css'
        ]

      release:
        options:
          sourcemap: 'none'
          style: 'compressed'
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'styles/**/*.{sass,scss}'
            'elements/**/*.{scss,sass}'
            'testing/**/*.{scss,sass}'
          ]
          dest: BUILD_DIR
          ext: '.css'
        ]

    coffee:
      options:
        bare: true
        join: false
      dev:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'scripts/**/*.coffee'
            'elements/**/*.coffee'
            'testing/**/*.coffee'
          ]
          dest: BUILD_DIR
          ext: '.js'
        ]

      release:
        options:
          sourceMap: false
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'scripts/**/*.coffee'
            'elements/**/*.coffee'
            'testing/**/*.coffee'
          ]
          dest: BUILD_DIR
          ext: '.js'
        ]

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app:
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            'scripts/**/*.coffee'
            'elements/**/*.coffee'
            'testing/**/*.coffee'
          ]
          dest: BUILD_DIR
          ext: '.js'
        ]

    autoprefixer:
      options:
        browsers: [
          'last 1 versions'
        #  'Chrome'
        #  'ChromeAndroid'
        #  'Firefox'
        #  'FirefoxAndroid'
        ]

      dev:
        options:
          map: true
          cascade: true
        files: [
          expand: true
          cwd: BUILD_DIR
          src: '**/*.css'
          dest: BUILD_DIR
        ]

      release:
        options:
          map: false
          cascade: false
        files: [
          expand: true
          cwd: BUILD_DIR
          src: '**/*.css'
          dest: BUILD_DIR
        ]

    useminPrepare:
      html: BUILD_DIR + '/**/*.html'
      options:
        staging: TEMP_DIR
        dest: BUILD_DIR

    uglify:
      options:
        report: 'gzip'
        preserveComments: false
        banner: ''
        compress:
          unsafe: true
        beautify:
          beautify: false
          screw_ie8: true

    usemin:
      html: [
        BUILD_DIR + '/**/*.html'
        '!' + BUILD_DIR + '/bower_components/**/*.html'
        ]

    vulcanize:
      release:
        options:
          csp: false
          inline: true
          strip: false
        files:
          'build/index.html': BUILD_DIR + '/app.html'

    rename:
      dev:
        src: BUILD_DIR + '/app.html'
        dest: BUILD_DIR + '/index.html'
      release:
        src: BUILD_DIR + '/index.html'
        dest: RELEASE_DIR + '/index.html'

    clean:
      build:
        [
          RELEASE_DIR
          BUILD_DIR
          TEMP_DIR
          'coverage'
        ]
      uninstall:
        [
          RELEASE_DIR
          BUILD_DIR
          TEMP_DIR
          APP_DIR + '/bower_components'
          'node_modules'
          'coverage'
          '.bower'
          '.npm'
        ]
      lite:
        [
          RELEASE_DIR
          BUILD_DIR
          TEMP_DIR
          APP_DIR + '/bower_components'
          'node_modules'
          'coverage'
        ]
      postRelease:
        [
          BUILD_DIR
          TEMP_DIR
        ]

    watch:
      options:
        spawn: true
        livereload: true
        interrupt: true
        livereloadOnError: false

      html:
        files: [
          APP_DIR + '/app.html'
          APP_DIR + '/elements/**/*.html'
          APP_DIR + '/testing/**/*.html'
        ]
        tasks: [
          'copy:html'
          'dom_munger:coffee2js'
          'dom_munger:sass2css'
          'rename:dev'
        ]
      sass:
        files: [
          APP_DIR + '/styles/**/*.{sass,scss}'
          APP_DIR + '/elements/**/*.{scss,sass}'
          APP_DIR + '/testing/**/*.{scss,sass}'
        ]
        tasks: [
          'sass:dev'
          'autoprefixer:dev'
        ]
      coffee:
        files: [
          APP_DIR + '/scripts/**/*.coffee'
          APP_DIR + '/elements/**/*.coffee'
          APP_DIR + '/testing/**/*.coffee'
        ]
        tasks: [
          'coffeelint:app'
          'coffee:dev'
        ]

    connect:
      dev:
        options:
          port: 9000
          hostname: '*'
          base: [
            BUILD_DIR
            APP_DIR
            ''
          ]
          directory: APP_DIR
          livereload: true
      release:
        options:
          port: 9000
          hostname: '*'
          keepalive: true
          base: [
            RELEASE_DIR
          ]

    git_deploy:
      release:
        options:
          url: 'git@github.com:Klathmon/Table-Simulator.git'
          branch: 'gh-pages'
          message: 'autocommit'
        src: RELEASE_DIR

    gitpush:
      build:
        options:
          remote: 'origin'

    'wct-test':
      options:
        root: BUILD_DIR
        suites: ['testing/runner.html']
        testTimeout: 5 * 60 * 1000
        webserver:
          port: 9001
        #verbose: true
      local:
        options:
          plugins:
            local:
              browsers: [
                'chrome'
                'firefox'
                #'canary'
                #'ie'
              ]
            'web-component-tester-istanbul':
              dir: './coverage'
              reporters: [
                'text-summary'
                'json'
              ]
              include: [
                '/**/*.js'
              ]
              exclude: [
                '/bower_components/**/*.js'
                '/testing/*.js'
                '/**/tests/*.js'
              ]
      remote:
        options:
          tunnelOptions:
            tunnelDomains: 'localhost'
          browserOptions:
            name: 'Manual Build'
            tags: 'manual'
            'idleTimeout': 180
            'video-upload-on-pass': false
            build: 1
          plugins:
            sauce:
              browsers: [
                # Chrome
                {
                  browserName: 'chrome'
                  platform: 'Windows 8.1'
                  version: '40'
                }
                {
                  browserName: 'chrome'
                  platform: 'Linux'
                  version: '40'
                }
                {
                  browserName: 'chrome'
                  platform: 'OS X 10.10'
                  version: '40'
                }
                # Firefox
                {
                  browserName: 'firefox'
                  platform: 'Windows 8.1'
                  version: '35'
                }
                {
                  browserName: 'firefox'
                  platform: 'Linux'
                  version: '35'
                }
                {
                  browserName: 'firefox'
                  platform: 'OS X 10.10'
                  version: '35'
                }
                # Safari
                {
                  browserName: 'safari'
                  platform: 'OS X 10.10'
                  version: '8.0'
                }
                {
                  browserName: 'safari'
                  platform: 'OS X 10.9'
                  version: '7.0'
                }
                # Android
                {
                  browserName: 'android'
                  platform: 'Linux'
                  version: '4.4'
                }
                # iOS
                {
                  browserName: 'iphone'
                  platform: 'OS X 10.10'
                  version: '8.1'
                }
              ]
            'web-component-tester-istanbul':
              dir: './coverage'
              reporters: [
                'text-summary'
                'json'
              ]
              include: [
                '/**/*.js'
              ]
              exclude: [
                '/bower_components/**/*.js'
                '/testing/*.js'
                '/**/tests/*.js'
              ]
      remoteTravis:
        options:
          ttyOutput: false
          tunnelOptions:
            tunnelDomains: 'localhost'
          browserOptions:
            name: 'Travis Job ' + process.env.TRAVIS_JOB_NUMBER
            build: process.env.TRAVIS_BUILD_NUMBER
            tags: 'travis'
            'video-upload-on-pass': false
            'custom-data':
              branch: process.env.TRAVIS_BRANCH
              commit: process.env.TRAVIS_COMMIT
          plugins:
            sauce:
              browsers: [
                # Chrome
                {
                  browserName: 'chrome'
                  platform: 'Windows 8.1'
                  version: '40'
                }
                {
                  browserName: 'chrome'
                  platform: 'Linux'
                  version: '40'
                }
                {
                  browserName: 'chrome'
                  platform: 'OS X 10.10'
                  version: '40'
                }
                # Firefox
                {
                  browserName: 'firefox'
                  platform: 'Windows 8.1'
                  version: '35'
                }
                {
                  browserName: 'firefox'
                  platform: 'Linux'
                  version: '35'
                }
                {
                  browserName: 'firefox'
                  platform: 'OS X 10.10'
                  version: '35'
                }
                # Safari
                {
                  browserName: 'safari'
                  platform: 'OS X 10.10'
                  version: '8.0'
                }
                {
                  browserName: 'safari'
                  platform: 'OS X 10.9'
                  version: '7.0'
                }
                # Android
                {
                  browserName: 'android'
                  platform: 'Linux'
                  version: '4.4'
                }
                # iOS
                {
                  browserName: 'iphone'
                  platform: 'OS X 10.10'
                  version: '8.1'
                }
              ]
            'web-component-tester-istanbul':
              dir: './coverage'
              reporters: [
                'text-summary'
                'json'
              ]
              include: [
                '/**/*.js'
              ]
              exclude: [
                '/bower_components/**/*.js'
                '/testing/*.js'
                '/**/tests/*.js'
              ]

    coveralls:
      options:
        force: false
      build:
        src: 'coverage/lcov.info'

    devUpdate:
      main:
        options:
          updateType: 'prompt'
          semver: false

  grunt.registerTask 'convertCoverage', 'Convert coverage using sourcemaps', ->
    istanbul = require 'istanbul'
    istanbulCoverageSourceMap = require 'istanbul-coverage-source-map'

    done = @async()
    collector = new istanbul.Collector()
    reporter = new istanbul.Reporter false, './coverage'

    covObj = grunt.file.readJSON './coverage/coverage-final.json'
    covObjConverted = istanbulCoverageSourceMap(covObj,
      generatorPrefix: /(\.\.\/)/g)

    covObjConverted = JSON.parse covObjConverted


    newCovObj = {}
    cwd = process.cwd() + '\\'
    Object.keys(covObjConverted).forEach (value, index, array)->
      newValue = covObjConverted[value]
      newValue.path = newValue.path.replace(cwd, '')
      newCovObj[value.replace(cwd, '')] = newValue
      return

    collector.add covObjConverted
    reporter.add 'lcov'
    reporter.write collector, false, ->
      console.log 'Coverage reports converted.'
      done()
      return
    return


  grunt.registerTask 'buildDev', [
      'coffeelint:app'
      'copy:html'
      'dom_munger:coffee2js'
      'dom_munger:sass2css'
      'sass:dev'
      'coffee:dev'
      'autoprefixer:dev'
      'rename:dev'
    ]

  grunt.registerTask 'buildRelease', [
      'clean:build'
      'coffeelint:app'
      'copy:html'
      'copy:bower'
      'dom_munger:coffee2js'
      'dom_munger:sass2css'
      'sass:release'
      'coffee:release'
      'autoprefixer:release'
      'useminPrepare'
      'concat:generated'
      'usemin'
      'copy:fixusemin'
      'vulcanize:release'
      'rename:release'
    ]

  grunt.registerTask 'serveDev', [
      'clean:build'
      'buildDev'
      'connect:dev'
      'watch'
    ]

  grunt.registerTask 'testLocal', [
      'clean:build'
      'copy:bower'
      'buildDev'
      'wct-test:local'
      'convertCoverage'
    ]

  grunt.registerTask 'testRemote', [
      'clean:build'
      'copy:bower'
      'buildDev'
      'wct-test:remote'
      'convertCoverage'
    ]

  grunt.registerTask 'testTravis', [
      'clean:build'
      'copy:bower'
      'buildDev'
      'wct-test:remoteTravis'
      'convertCoverage'
      'coveralls:build'
      'clean:build'
    ]

  grunt.registerTask 'serveRelease', [
      'buildRelease'
      'connect:release'
    ]

  grunt.registerTask 'deployRelease', [
      'buildRelease'
      'copy:ghpages'
      'git_deploy:release'
    ]

  grunt.registerTask 'pushAndDeploy', [
      'gitpush:build'
      'deployRelease'
    ]

  return
