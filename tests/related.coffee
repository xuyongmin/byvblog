'use continuation'
related = require('../middlewares/related')

guid = process.argv[2]

if not guid?
  related.updateRelatedPosts obtain()
else
  related.updateRelatedPosts {guid: guid}, obtain()

console.log 'Done'
process.exit()
