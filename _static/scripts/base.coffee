'use strict'

$ = require 'jquery'
require 'infinitescroll'

$ ->
  $('.Posts').infinitescroll
    navSelector: '.Pagination'
    nextSelector: '.Pagination .next'
    itemSelector: '.Post'

  return
