
path = require 'path'

class MetaEngine

  optionMap: null
  contentProvider: null

  constructor: (optionMap = {})->

    @optionMap = optionMap = @__processOptionMap optionMap

    if optionMap.contentProvider
      @contentProvider = @__validateContentProvider optionMap.contentProvider


  setContentProvider: (contentProvider)->
    
    @contentProvider = @__validateContentProvider contentProvider


  __validateContentProvider: (contentProvider)->

    if not ('getContent' of contentProvider) or not (typeof contentProvider.getContent is 'function')
      throw new Error 'contentProvider does not implement getContent'

    if not ('setContent' of contentProvider) or not (typeof contentProvider.setContent is 'function')
      throw new Error 'contentProvider does not implement setContent'

    if not ('getContentSync' of contentProvider) or not (typeof contentProvider.getContentSync is 'function')
      throw new Error 'contentProvider does not implement getContentSync'

    if not ('setContentSync' of contentProvider) or not (typeof contentProvider.setContentSync is 'function')
      throw new Error 'contentProvider does not implement setContentSync'

    return contentProvider
  

  __processOptionMap: (optionMap)->

    if not optionMap or not (typeof optionMap is 'object')
      optionMap = {}

    if not ('encoding' of optionMap) or not (typeof optionMap.encoding is 'string')
      optionMap.encoding = 'utf8'

    if not ('prefix' of optionMap) or not (typeof optionMap.prefix is 'string')
      optionMap.prefix = '@'

    if not ('postfix' of optionMap) or not (typeof optionMap.postfix is 'string')
      optionMap.postfix = ''

    if not ('indentCharacter' of optionMap) or not (typeof optionMap.indentCharacter is 'string')
      optionMap.indentCharacter = '  '

    if not ('linebreakCharacter' of optionMap) or not (typeof optionMap.linebreakCharacter is 'string')
      optionMap.linebreakCharacter = '\n'

    if not ('contentProvider' of optionMap) or not (typeof optionMap.contentProvider is 'object')
      optionMap.contentProvider = null

    return optionMap


  __ensureContentProvider: ->

    unless @contentProvider
      throw new Error "contentProvider is not assigned"

  # ---------------------------------------------------------- Sync Version

  __processSyncIncludeTag: (resourcePath, content)->

    linebreakCharacter = @optionMap.linebreakCharacter

    indentCharacter = @optionMap.indentCharacter

    offset = 0
    while (tagStartIndex = content.indexOf '@include', offset) > -1
      offset = tagStartIndex + 1
      
      # figure out indent level
      if tagStartIndex is 0
        indentLevel = 0
        tagLineStartIndex = 0
      else
        caseContent = content.slice 0, tagStartIndex
        lastLineEnd = caseContent.lastIndexOf linebreakCharacter
        tagLineStartIndex = lastLineEnd + 1 # NOTE: Also covers the scenario when lastLineEnd is -1
        indentationString = content.slice tagLineStartIndex, tagStartIndex
        indentLevel = 0
        while (indentationString.indexOf indentCharacter, (indentCharacter.length * indentLevel)) > -1
          indentLevel += 1

      # extract tag
      tagLineEndIndex = (content.indexOf linebreakCharacter, offset)
      if tagLineEndIndex is -1
        tagLineEndIndex = content.length - 1
      tag = (content.slice tagStartIndex, tagLineEndIndex)

      # extract name
      indexQuote1 = tag.indexOf '"', '@include'.length
      if indexQuote1 is -1
        throw new Error 'Expected Double Quote'
      indexQuote2 = tag.indexOf '"', indexQuote1 + 1
      if indexQuote2 is -1
        throw new Error 'Expected Double Quote'
      name = tag.slice indexQuote1 + 1, indexQuote2

      # extract other parameters
      if ((tag.slice indexQuote2 + 1, tag.length).indexOf 'isolated') > -1
        isolated = true
      else
        isolated = false

      # extract subContent (recursive)
      subResourcePath = path.join (path.dirname resourcePath), name
      subContent = @__processSync subResourcePath, isolated

      # replace
      left = content.slice 0, tagLineStartIndex
      middle = subContent
      right = content.slice tagLineEndIndex, content.length
      content = left + middle + right

    return content


  __processSyncRegionTag: (resourcePath, content)->

    linebreakCharacter = @optionMap.linebreakCharacter

    indentCharacter = @optionMap.indentCharacter

    regionMap = {}

    offset = 0
    while (tagStartIndex = content.indexOf '@region', offset) > -1
      offset = tagStartIndex + 1
      
      # figure out indent level
      if tagStartIndex is 0
        indentLevel = 0
        tagLineStartIndex = 0
      else
        caseContent = content.slice 0, tagStartIndex
        lastLineEnd = caseContent.lastIndexOf linebreakCharacter
        tagLineStartIndex = lastLineEnd + 1 # NOTE: Also covers the scenario when lastLineEnd is -1
        indentationString = content.slice tagLineStartIndex, tagStartIndex
        indentLevel = 0
        while (indentationString.indexOf indentCharacter, (indentCharacter.length * indentLevel)) > -1
          indentLevel += 1

      # extract tag
      tagLineEndIndex = (content.indexOf linebreakCharacter, offset)
      if tagLineEndIndex is -1
        tagLineEndIndex = content.length - 1
      tag = (content.slice tagStartIndex, tagLineEndIndex)

      # extract name
      indexQuote1 = tag.indexOf '"', '@region'.length
      if indexQuote1 is -1
        throw new Error 'Expected Double Quote'
      indexQuote2 = tag.indexOf '"', indexQuote1 + 1
      if indexQuote2 is -1
        throw new Error 'Expected Double Quote'
      name = tag.slice indexQuote1 + 1, indexQuote2

      # extract other parameters
      if ((tag.slice indexQuote2 + 1, tag.length).indexOf 'indented') > -1
        indented = true
      else
        indented = false

      # check for duplication
      if name of regionMap
        throw new Error "Duplicate Region #{name}"

      # locate the region
      localOffset = offset
      endOfBlockString = linebreakCharacter + (indentCharacter for i in [0...indentLevel]).join ''
      inBlockString = linebreakCharacter + (indentCharacter for i in [0...(indentLevel + 1)]).join ''
      loop
        endOfBlockStringIndex = content.indexOf endOfBlockString, localOffset
        inBlockStringIndex = content.indexOf inBlockString, localOffset
        break if endOfBlockStringIndex is -1
        break unless endOfBlockStringIndex is inBlockStringIndex
        localOffset = endOfBlockStringIndex + 1
      endOfBlockStringIndex = content.length if endOfBlockStringIndex is -1

      # extract the region
      regionContent = (content.slice (tagLineEndIndex+1), endOfBlockStringIndex)
      regionContent = (linebreakCharacter + regionContent).split inBlockString
      regionContent = (regionContent.join endOfBlockString).slice 1

      # replace
      left = content.slice 0, tagLineStartIndex
      middle = ''
      right = content.slice (endOfBlockStringIndex + 1), content.length
      content = left + middle + right

      # add
      regionMap[name] = {
        resourcePath: resourcePath,
        regionContent: regionContent
        indented: indented
        indentLevel: indentLevel
      }

    return [ regionMap, content ]




  __processSync: (resourcePath, isolated = false)->

    content = @contentProvider.getContentSync resourcePath

    content = @__processSyncIncludeTag resourcePath, content

    if isolated

      [ regionMap, content ] = @__processSyncRegionTag resourcePath, content

      content = @__processSyncUseTag resourcePath, content, regionMap

    return content


  processSync: (resourcePath)->

    @__ensureContentProvider()

    return @__processSync resourcePath, true



@MetaEngine = MetaEngine

