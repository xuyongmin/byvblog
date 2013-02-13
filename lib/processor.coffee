child_process = require('child_process')

processor = null

exports.started = false

exports.start = (next) ->
  cmd = 'continuation'
  args = [__dirname + '/background.coffee', '--explicit', '--cache']
  options = stdio: ['ipc']
  processor = child_process.spawn cmd, args, options

  processor.on 'message', (data) ->
    if data is 'started'
      exports.started = true
      next() if next?
      next = null
    else
      console.log data

  processor.stdout.on 'data', (data) ->
    process.stdout.write data

  processor.stderr.on 'data', (data) ->
    process.stderr.write data

exports.updateRelatedPosts = (post) ->
  try
    processor.send
      method: 'updateRelatedPosts'
      args: [post]
  catch err
    console.error err
