'use continuation'
related = require('../middlewares/related')

guid = process.argv[2]

if name?
  related.updateRelatedPosts obtain()
else
  related.updateRelatedPosts guid obtain()

console.log 'Done'
process.exit()
