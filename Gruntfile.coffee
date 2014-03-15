'use strict'

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt

  grunt.initConfig
    docs:
      assets: 'assets'
      path: 'dist'
      version: grunt.file.readJSON('bower.json').dependencies.bradypodion
      docs: 'bower_components/bradypodion/docs'
      app: 'bower_components/bradypodion/modules'
      token: process.env.GH_TOKEN

    clean:
      dist: '<%=docs.path%>'

    ngdocs:
      options:
        dest: '<%=docs.path%>/<%=docs.version%>/'
        title: 'Bradypodion'
        titleLink: 'http://bradypodion.io/'
        startPage: 'api'
        navTemplate: '<%=docs.docs%>/navigation.html'
        html5Mode: off
        bestMatch: on
      guides:
        src: ['<%=docs.docs%>/content/guides/**/*.ngdoc']
        title: 'Guides'
      api:
        src: ['<%=docs.docs%>/content/api/**/*.ngdoc', '<%=docs.app%>/scripts/**/*.js']
        title: 'Documentation'

    copy:
      index:
        files: '<%=docs.path%>/index.html': ['<%=docs.assets%>/index.html']
        options:
          process: (content, srcpath) ->
            grunt.template.process content
      assets:
        expand: yes
        cwd: '<%=docs.assets%>'
        src: '*/**/*'
        dest: '<%=docs.path%>/<%=docs.version%>'

    'gh-pages':
      options:
        base: '<%=docs.path%>/'
        add: yes
        tag: 'v<%=docs.version%>'
        message: 'docs: deployed v<%=docs.version%>'
        user:
          name: 'bpBot'
          email: 'bot@bradypodion.io'
        repo: 'https://<%=docs.token%>@github.com/excellenteasy/docs.bradypodion.io.git'
      src: '**/*'


  grunt.registerTask 'default', [
    'clean'
    'ngdocs'
    'copy'
  ]