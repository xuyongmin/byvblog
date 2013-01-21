'use continuation'
related = require('../middlewares/related')

logError = ->
  console.error.apply console, arguments

log = ->
  console.log.apply console, arguments

methods = {}

process.on 'message', (msg) ->
  return logError('[InvalidMessage]', msg) if not msg or not msg.method
  msg.args ?= []
  methods[msg.method].apply global, msg.args

methods.updateRelatedPosts = (post) ->
  try
    log 'updateRelatedPosts'
    related.updateRelatedPosts post, obtain()
    log 'Done updateRelatedPosts'
  catch err
    logError 'updateRelatedPosts', err

process.send 'started'
