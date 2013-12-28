fs = require('fs')
opencc = require('opencc')

openccZhsToZht = new opencc('s2t.json')
openccZhtToZhs = new opencc('t2s.json')

exports.zhsToZht = (text, callback) ->
  openccZhsToZht.convert text, callback

exports.zhtToZhs = (text, callback) ->
  openccZhtToZhs.convert text, callback
