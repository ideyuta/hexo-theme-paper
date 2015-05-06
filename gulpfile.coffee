'use strict'

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
browserify = require 'browserify'
browserSync = require 'browser-sync'
gutil = require 'gulp-util'
del = require 'del'
exec = require('child_process').exec
mainBowerFiles = require 'main-bower-files'
runSequence = require 'run-sequence'
source = require 'vinyl-source-stream'

dirs =
  src: './_static'
  dist: './source'

paths =
  coffee: ["#{dirs.src}/scripts/**/*.coffee"]
  browserify: ["#{dirs.src}/scripts/base.coffee"]


###
# JS
###

# JS 生成 (browserify)
gulp.task 'js', ->
  browserify
    entries: paths.browserify
    extensions: ['.coffee', '.js']
  .bundle()
  .pipe source "base.js"
  .pipe gulp.dest "#{dirs.dist}/js/"

# JS 最適化
gulp.task 'optimizeJS', ->
  gulp.src ["#{dirs.dist}/js/**/*{.*,}[^.min].js"]
    .pipe $.using()
    .pipe $.size()
    .pipe $.uglify()
    .pipe $.size title: 'minify'
    .pipe $.rename extname: '.min.js'
    .pipe gulp.dest "#{dirs.dist}/js/"

# 本番用 JS 生成
gulp.task 'prodJS', (cb) ->
  runSequence 'js', 'optimizeJS', cb


###
# Util
###
# 本番判定
isProduction = ->
  process.env.ENV is 'production'

# エラー制御とNotify
plumberWithNotify = ->
  $.plumber errorHandler: (error) ->
    if not isProduction()
      $.notify.onError('<%= error.message %>') error
    @emit 'end'

# 確認用サーバ起動
gulp.task 'server', ->
  browserSync
    server:
      baseDir: dirs.dist

# ファイル監視とライブリロード
gulp.task 'watch', ->
  gulp.watch paths.browserify, ['js', browserSync.reload]


###
# Task
###

# ビルドディレクトリのcleaning
gulp.task 'clean', del.bind null, ["#{dirs.dist}/js/"]

# デフォルトタスク (確認サーバ起動とファイル監視)
gulp.task 'default', ['server', 'watch']

# 本番用ファイル生成タスク
gulp.task 'build', ->
  env = 'production'
  runSequence 'clean', 'prodJS'
