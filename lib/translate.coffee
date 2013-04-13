fs = require('fs')
opencc = require('opencc')

openccZhsToZht = new opencc('zhs2zht.ini')
openccZhtToZhs = new opencc('zht2zhs.ini')

exports.zhsToZht = (text, callback) ->
  openccZhsToZht.convert text, callback

exports.zhtToZhs = (text, callback) ->
  openccZhtToZhs.convert text, callback
