processor = require('../lib/processor')
Post = require('../models/post')

processor.start ->
  Post.findOne {}, (err, post) ->
    processor.updateRelatedPosts(post)
