'use strict';
module.exports = function (grunt) {
  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    watch: {
      jade: {
        files: '**/*.jade',
        tasks: 'jade'
      },
      coffee: {
        files: '**/*.coffee',
        tasks: 'coffee'
      },
      less: {
        files: '**/*.less',
        tasks: 'less'
      }
    },
    jade: {
      build: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['**/*.jade', '!node_modules/**/*'],
          dest: '.',
          ext: '.html'
        }],
      }
    },
    coffee: {
      build: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['**/*.coffee', '!node_modules/**/*'],
          dest: '.',
          ext: '.js'
        }],
      }
    },
    less: {
      build: {
        files: [{
          expand: true,
          cwd: '.',
          src: ['**/*.less', '!node_modules/**/*'],
          dest: '.',
          ext: '.css'
        }],
      }
    },
  });

  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['jade', 'coffee', 'less']);
};
