'use strict'

$ = require 'jquery'
require 'infinitescroll'

$ ->
  $('.Posts').infinitescroll
    loading:
      finished: undefined
      finishedMsg: null
      img: '/images/nakajima.gif'
      msg: null
      msgText: ""
      selector: null
      speed: 'fast'
      start: undefined
    navSelector: '.Pagination'
    nextSelector: '.Pagination .next'
    itemSelector: '.Post'

  return
