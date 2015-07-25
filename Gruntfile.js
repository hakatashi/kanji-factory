'use strict';
module.exports = function (grunt) {
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    watch: {
      jade: {
        files: '{,*/}*.jade',
        tasks: 'jade'
      },
      coffee: {
        files: '{,*/}*.coffee',
        tasks: 'coffee'
      },
      less: {
        files: '{,*/}*.less',
        tasks: 'less'
      }
    },
    jade: {
      build: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['{,*/}*.jade'],
          dest: '.',
          ext: '.html'
        }],
      }
    },
    browserify: {
      build: {
        files: {
          'index.js': ['index.coffee']
        },
        options: {
          transform: ['coffeeify']
        }
      }
    },
    uglify: {
      build: {
        files: {
          'index.min.js': ['index.js']
        },
        options: {
          report: 'min'
        }
      }
    },
    less: {
      build: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['{,*/}*.less'],
          dest: '.',
          ext: '.css'
        }],
      }
    },
  });

  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['jade', 'browserify', 'uglify', 'less']);
};
