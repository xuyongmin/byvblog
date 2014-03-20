'use continuation'
Post = require('../models/post')
config = require('../config')
translate = require '../lib/translate'

Segment = require('node-segment').Segment
segment = new Segment()
segment.useDefault()
segment.loadDict('dict.txt')
segment.loadDict('dict2.txt')
segment.loadDict('names.txt')
segment.loadDict('stopword.txt')
segment.loadDict('synonym.txt')
segment.loadDict('wildcard.txt')

segmentation = (post, callback) ->
  content = post.contents[0]
  contents = content.contents
  if content.language is 'zhs'
    translate.zhsToZht content.contents, obtain(contents)
  segments = segment.doSegment(contents)
  words = {}
  for seg in segments
    words[seg.w] ?= 0
    words[seg.w]++
  post.words = words
  callback null

similarity = (post1, post2) ->
  if not post1.words?
    segmentation post1, obtain()
  if not post2.words?
    segmentation post2, obtain()
  
  dist = 0
  calc = {}
  calcDist = (from) ->
    for word in Object.keys(from)
      if not calc[word]
        calc[word] = true
        p1 = post1.words[word]
        p2 = post2.words[word]
        p1 ?= 0
        p2 ?= 0
        d = (p1 - p2) * (p1 - p2)
        dist += d
  calcDist post1.words
  calcDist post2.words
  
  return 10000000 / dist

usePostMap = false
postMap = {}
exports.relatedPosts = (post, count, next) ->
  selfPost = post.toObject()
  #Get posts which have at least one common tag with selfPost
  potRelatedPosts = {}
  for tag in selfPost.tags
    Post.find {tags: tag, private:false, list:true}, obtain(posts)
    for post in posts
      potRelatedPosts[post.guid] = post.toObject()
  posts = []
  for guid in Object.keys(potRelatedPosts)
    if usePostMap and postMap[guid]
      post = postMap[guid]
    else
      post = potRelatedPosts[guid]
      if usePostMap
        postMap[guid] = post
    posts.push post
  #Calculate similarity
  targets = []
  for target in posts
    if selfPost.guid isnt target.guid
      target.similarity = similarity(selfPost, target)
      targets.push target
  targets.sort (a, b) ->
    if a.similarity > b.similarity then -1 else 1
  next null, targets.slice(0, count)

exports.updateRelatedPosts = (targetPost, next) ->
  if targetPost? and next?
    #single post
    Post.findOne {guid: targetPost.guid}, obtain(post)
    posts = [post]
  else
    next = targetPost if not next?
    usePostMap = true
    Post.find {list:true}, obtain(posts)
  i = 0
  for post in posts
    i += 1
    console.log i, posts.length, post.id, post.contents[0].title
    relatedPosts = []
    exports.relatedPosts post, config.options.relatedPosts, obtain(relatedPosts)
    related = []
    for p in relatedPosts
      related.push p.guid
    post.related = related
    post.save obtain()
  usePostMap = false
  postMap = {}
  next null
