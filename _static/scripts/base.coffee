'use strict'

$ = require 'jquery'
require 'infinitescroll'
require 'lazysizes'
attachFastClick = require 'fastclick'


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


class LikeCount

  constructor: (el) ->
    @$el = $ el
    @$count = @$el.find('.count')
    @url = @$el.data 'url'

    if @$count.empty
      @getCount @url, (count) =>
        @$count.html count

  getCount: (url, cb) ->
    $.ajax
      url: "http://graph.facebook.com/?id=" + encodeURIComponent(url)
      type: 'get'
      dataType: 'jsonp'
      success: (response) ->
        if typeof response.shares == 'undefined'
          cb 0
        else
          cb response.shares
      error: (response) ->
        do cb

class HatebuCount

  constructor: (el) ->
    @$el = $ el
    @$count = @$el.find('.count')
    @url = @$el.data 'url'

    if @$count.empty
      @getCount @url, (count) =>
        @$count.html count

  getCount: (url, cb) ->
    $.ajax
      url: "http://api.b.st-hatena.com/entry.count?url=" + encodeURIComponent(url)
      type: 'get'
      dataType: 'jsonp'
      success: (response) ->
        if typeof response == 'undefined'
          cb 0
        else
          cb response
      error: (response) ->
        do cb


$ ->
  attachFastClick document.body

  ide.postInit = =>
    $('.tweet').each -> new TweetCount @
    $('.like').each -> new LikeCount @
    $('.hatebu').each -> new HatebuCount @

  ide.postInit()

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
    ide.postInit()

  return
