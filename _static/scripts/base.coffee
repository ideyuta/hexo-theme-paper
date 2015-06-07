'use strict'

$ = require 'jquery'
require 'infinitescroll'

class TweetCount

  constructor: (el) ->
    @$el = $ el
    @$count = @$el.find('.count')
    @url = @$el.data 'url'

    if @$count.empty
      @getCount @url, (count) =>
        @$count.html count

  getCount: (url, cb) ->
    $.ajax
      url: "http://urls.api.twitter.com/1/urls/count.json?url=" + encodeURIComponent(url)
      type: 'get'
      dataType: 'jsonp'
      success: (response) ->
        cb response.count
      error: (response) ->
        do cb


$ ->
  $('.tweet').each -> new TweetCount @

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
  , ->
    $('.tweet').each -> new TweetCount @

  return
