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
        loadPath: [APP_DIR + '/styles/partials']

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
        testTimeout: 90 * 1000
        #verbose: true
      local:
        options:
          #persistent: true
          remote: false
          browsers: [
            'chrome'
            'firefox'
          ]
      remote:
        options:
          remote: true
          browserOptions:
            name: 'Manual Build'
            tags: 'manual'
            'video-upload-on-pass': false
          browsers: [
            # 100% Supported
            'Windows 8.1/Chrome@39'
            'Windows 8/Chrome@39'
            'Windows 7/Chrome@39'
            'OS X 10.10/Chrome@39'
            'Linux/Chrome@39'

            # Supported as Client
            'Windows 8.1/Firefox@34'
            'Windows 8/Firefox@34'
            'Windows 7/Firefox@34'
            'OS X 10.10/Firefox@34'
            'Linux/Firefox@34'

            # Not supported but might work
            'OS X 10.10/Safari@8'
            'Windows 8.1/Internet Explorer@11'
            'Windows 7/Internet Explorer@11'
            'Windows 8/Internet Explorer@10'
            'Windows 7/Internet Explorer@10'

            # Mobile
            'Linux/Android@4.4'
            'Linux/Android@4.3'
            'OS X 10.9/iPhone@8.1'
            'OS X 10.9/iPad@8.1'
          ]
      remoteTravis:
        options:
          remote: true
          ttyOutput: false
          browserOptions:
            name: 'Travis Job ' + process.env.TRAVIS_JOB_NUMBER
            build: process.env.TRAVIS_BUILD_NUMBER
            tags: 'travis'
            'video-upload-on-pass': false
            'custom-data':
              branch: process.env.TRAVIS_BRANCH
              commit: process.env.TRAVIS_COMMIT
          browsers: [
            # 100% Supported
            'Windows 8.1/Chrome@dev'
            'Windows 8.1/Chrome@beta'
            'Windows 8.1/Chrome@39'
            'Windows 8/Chrome@39'
            'Windows 7/Chrome@39'
            'OS X 10.10/Chrome@39'
            'Linux/Chrome@39'

            # Supported as Client
            #'Windows 8.1/Firefox@dev'
            'Windows 8.1/Firefox@beta'
            'Windows 8.1/Firefox@34'
            'Windows 8/Firefox@34'
            'Windows 7/Firefox@34'
            'OS X 10.10/Firefox@34'
            'Linux/Firefox@34'

            # Not supported but might work
            #'OS X 10.10/Safari@8'

            # Mobile
            'Linux/Android@4.4'
            #'Linux/Android@4.3'
            #'OS X 10.9/iPhone@8.1'
            #'OS X 10.9/iPad@8.1'
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
    ]

  grunt.registerTask 'testRemote', [
      'clean:build'
      'copy:bower'
      'buildDev'
      'wct-test:remote'
      'coveralls:build'
    ]

  grunt.registerTask 'testTravis', [
      'clean:build'
      'copy:bower'
      'buildDev'
      'wct-test:remoteTravis'
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
