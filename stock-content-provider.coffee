
path = require 'path'

class StockContentProvider

  constructor: (rootDir = './', encoding = 'utf8') ->
    
    unless fs.existsSync rootDir
      throw new Error "#{rootDir} does not exist."

    if not (encoding) or not (typeof encoding is 'string')
      encoding = 'utf8'

    @rootDir = rootDir
    @encoding = encoding

  getContent: ->
    throw new Error 'Not Implemented'

  setContent: ->
    throw new Error 'Not Implemented'

  getContentSync: (relativePath)->
    actualPath = path.join @rootDir, relativePath
    content = fs.readFileSync actualPath, { encoding: @encoding }
    return content

  setContentSync: (relativePath, content)->
    actualPath = path.join @rootDir, relativePath
    fs.writeFileSync actualPath, content, { encoding: @encoding }
    return

@StockContentProvider = StockContentProvider