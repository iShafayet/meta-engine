
path = require 'path'

class MetaEngine

  optionMap: null

  contentProvider: null

  @defaults = 
    encoding: 'utf8'
    prefix: '@'
    postfix: ''
    indentCharacter: '  '
    linebreakCharacter: '\n'
    contentProvider: null
    insertComments: false
    commentPrefix: '<!-- '
    commentPostfix: ' -->'
    presetRegions: {}

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
      optionMap.encoding = MetaEngine.defaults.encoding

    if not ('prefix' of optionMap) or not (typeof optionMap.prefix is 'string')
      optionMap.prefix = MetaEngine.defaults.prefix

    if not ('postfix' of optionMap) or not (typeof optionMap.postfix is 'string')
      optionMap.postfix = MetaEngine.defaults.postfix

    if not ('indentCharacter' of optionMap) or not (typeof optionMap.indentCharacter is 'string')
      optionMap.indentCharacter = MetaEngine.defaults.indentCharacter

    if not ('linebreakCharacter' of optionMap) or not (typeof optionMap.linebreakCharacter is 'string')
      optionMap.linebreakCharacter = MetaEngine.defaults.linebreakCharacter

    if not ('contentProvider' of optionMap) or not (typeof optionMap.contentProvider is 'object')
      optionMap.contentProvider = MetaEngine.defaults.contentProvider

    if not ('insertComments' of optionMap) or not (typeof optionMap.insertComments is 'boolean')
      optionMap.insertComments = MetaEngine.defaults.insertComments

    if not ('commentPrefix' of optionMap) or not (typeof optionMap.commentPrefix is 'string')
      optionMap.commentPrefix = MetaEngine.defaults.commentPrefix

    if not ('commentPostfix' of optionMap) or not (typeof optionMap.commentPostfix is 'string')
      optionMap.commentPostfix = MetaEngine.defaults.commentPostfix

    if not ('presetRegions' of optionMap) or not (typeof optionMap.presetRegions is 'object')
      optionMap.presetRegions = MetaEngine.defaults.presetRegions

    return optionMap


  __ensureContentProvider: ->

    unless @contentProvider
      throw new Error "contentProvider is not assigned"

  # ---------------------------------------------------------- Actual Processing

  __extractCommonOptions: (tagString, otherParameterList, resourcePath, content, tagStartIndex, linebreakCharacter, indentCharacter)->

    # [ tagLineStartIndex, indentLevel ]
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

    # [ tagLineEndIndex, tag ]
    tagLineEndIndex = (content.indexOf linebreakCharacter, tagStartIndex)
    if tagLineEndIndex is -1
      tagLineEndIndex = content.length - 1
    tag = (content.slice tagStartIndex, tagLineEndIndex)

    # [ primaryQuotedString ]
    indexQuote1 = tag.indexOf '"', tagString.length
    if indexQuote1 is -1
      throw new Error "Expected Double Quote in \"#{resourcePath}\""
    indexQuote2 = tag.indexOf '"', indexQuote1 + 1
    if indexQuote2 is -1
      throw new Error "Expected Double Quote in \"#{resourcePath}\""
    primaryQuotedString = name = tag.slice indexQuote1 + 1, indexQuote2

    # [ otherParameterMap ]
    otherParameterMap = {}
    for parameter in otherParameterList
      if (tag.indexOf parameter, indexQuote2 + 1) > -1
        otherParameterMap[parameter] = true
      else
        otherParameterMap[parameter] = false

    return [ tagLineStartIndex, indentLevel, tagLineEndIndex, tag, primaryQuotedString, otherParameterMap ]

  __extractNextIncludeTag: (resourcePath, content, offset)->

    tagString = @optionMap.prefix + 'include' + @optionMap.postfix
    { linebreakCharacter, indentCharacter } = @optionMap

    tagStartIndex = content.indexOf tagString, offset
    return [ -1, null ] if tagStartIndex is -1

    res = @__extractCommonOptions tagString, ['isolated'], resourcePath, content, tagStartIndex, linebreakCharacter, indentCharacter
    return [ tagStartIndex, res ]

  __insertIncludeTagContents: ( resourcePath, subResourcePath, subContent, content, tagLineStartIndex, tagLineEndIndex ) ->

    # insert comments
    if @optionMap.insertComments
      beginComments = @optionMap.commentPrefix + "start of inclusion from \"#{subResourcePath}\" into \"#{resourcePath}\"" + @optionMap.commentPostfix
      endComments = @optionMap.commentPrefix + "end of inclusion \"#{subResourcePath}\"" + @optionMap.commentPostfix
      subContent = beginComments + subContent + endComments

    # replace
    left = content.slice 0, tagLineStartIndex
    middle = subContent
    right = content.slice tagLineEndIndex, content.length
    content = left + middle + right

    return content


  __processIncludeTag: (resourcePath, content, cbfn, offset = 0)->

    [ tagStartIndex, res ] = @__extractNextIncludeTag resourcePath, content, offset
    if tagStartIndex is -1
      return cbfn null, content

    [ tagLineStartIndex, indentLevel, tagLineEndIndex, tag, primaryQuotedString, otherParameterMap ] = res
    offset = tagStartIndex + 1
    
    subResourcePath = path.join (path.dirname resourcePath), primaryQuotedString
    
    # extract subContent (recursive)
    @__process subResourcePath, otherParameterMap.isolated, true, (err, subContent)=>

      return cbfn err if err

      content = @__insertIncludeTagContents resourcePath, subResourcePath, subContent, content, tagLineStartIndex, tagLineEndIndex
      
      @__processIncludeTag resourcePath, content, cbfn, offset


  __processSyncIncludeTag: (resourcePath, content)->

    offset = 0
    loop
      [ tagStartIndex, res ] = @__extractNextIncludeTag resourcePath, content, offset
      break if tagStartIndex is -1
      [ tagLineStartIndex, indentLevel, tagLineEndIndex, tag, primaryQuotedString, otherParameterMap ] = res
      offset = tagStartIndex + 1
      
      subResourcePath = path.join (path.dirname resourcePath), primaryQuotedString

      # extract subContent (recursive)
      subContent = @__processSync subResourcePath, otherParameterMap.isolated

      content = @__insertIncludeTagContents resourcePath, subResourcePath, subContent, content, tagLineStartIndex, tagLineEndIndex

    return content


  __processRegionTag: (resourcePath, content)->

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
        throw new Error "Expected Double Quote in \"#{resourcePath}\""
      indexQuote2 = tag.indexOf '"', indexQuote1 + 1
      if indexQuote2 is -1
        throw new Error "Expected Double Quote in \"#{resourcePath}\""
      name = tag.slice indexQuote1 + 1, indexQuote2

      # extract other parameters
      if ((tag.slice indexQuote2 + 1, tag.length).indexOf 'indented') > -1
        indented = true
      else
        indented = false

      # check for duplication
      if name of regionMap
        err = new Error "Duplicate Region \"#{name}\" in \"#{resourcePath}\""
        throw err

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


  __processUseTag: (resourcePath, content, regionMap)->

    linebreakCharacter = @optionMap.linebreakCharacter

    indentCharacter = @optionMap.indentCharacter

    offset = 0
    while (tagStartIndex = content.indexOf '@use', offset) > -1
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
      indexQuote1 = tag.indexOf '"', '@use'.length
      if indexQuote1 is -1
        throw new Error "Expected Double Quote in \"#{resourcePath}\""
      indexQuote2 = tag.indexOf '"', indexQuote1 + 1
      if indexQuote2 is -1
        throw new Error "Expected Double Quote in \"#{resourcePath}\""
      name = tag.slice indexQuote1 + 1, indexQuote2

      # extract other parameters
      if ((tag.slice indexQuote2 + 1, tag.length).indexOf 'as-is') > -1
        asIs = true
      else
        asIs = false

      # extract other parameters
      if ((tag.slice indexQuote2 + 1, tag.length).indexOf 'match-indent') > -1
        matchIndent = true
        if asIs
          throw new Error "match-indent and as-is may not be used in the same @use tag in \"#{resourcePath}\""
      else
        matchIndent = false

      # check for duplication
      unless name of regionMap
        throw new Error "Unknown Region \"#{name}\" in \"#{resourcePath}\""
      region = regionMap[name]

      regionContent = region.regionContent

      # insert comments
      if @optionMap.insertComments
        fillerString = (indentCharacter for i in [0...indentLevel]).join ''
        beginComments = @optionMap.commentPrefix + "start of use of \"#{name}\"" + @optionMap.commentPostfix
        endComments = @optionMap.commentPrefix + "end of use" + @optionMap.commentPostfix
        regionContent = beginComments + '\n' + regionContent + '\n' + endComments

      # decide whether to match indentation
      matchIndent = if matchIndent or (region.indented and not asIs) then true else false

      # match indent
      if matchIndent
        fillerString = (indentCharacter for i in [0...indentLevel]).join ''
        # regionContent = region.regionContent
        regionContent = regionContent.split linebreakCharacter
        regionContent = fillerString + regionContent.join linebreakCharacter + fillerString

      # replace
      left = content.slice 0, tagLineStartIndex
      middle = regionContent
      right = content.slice tagLineEndIndex, content.length
      content = left + middle + right

    return content


  __trim: (content)->
    content = content.replace /^\s*/g, ''
    content = content.replace /\s*$/g, ''
    return content


  __processSync: (resourcePath, isolated = false, trim = true)->

    content = @contentProvider.getContentSync resourcePath

    content = @__processSyncIncludeTag resourcePath, content

    if isolated

      [ regionMap, content ] = @__processRegionTag resourcePath, content

      if @optionMap.presetRegions
        for name, region of @optionMap.presetRegions
          regionMap[name] = region

      content = @__processUseTag resourcePath, content, regionMap

      content = @__trim content if trim

    return content

  __process: (resourcePath, isolated = false, trim = true, cbfn)->

    @contentProvider.getContent resourcePath, (err, content)=>

      return cbfn err if err

      @__processIncludeTag resourcePath, content, (err, content)=>

        return cbfn err if err

        if isolated

          try

            [ regionMap, content ] = @__processRegionTag resourcePath, content

            if @optionMap.presetRegions
              for name, region of @optionMap.presetRegions
                regionMap[name] = region

            content = @__processUseTag resourcePath, content, regionMap

            content = @__trim content if trim

          catch ex
            
            return cbfn ex

        return cbfn null, content


  processSync: (resourcePath)->

    @__ensureContentProvider()

    content = @__processSync resourcePath, true

    @contentProvider.setContentSync resourcePath, content

  process: (resourcePath, cbfn)->

    @__ensureContentProvider()

    @__process resourcePath, true, true, (err, content)=>

      return cbfn err if err

      @contentProvider.setContent resourcePath, content, (err)=>

        return cbfn err



@MetaEngine = MetaEngine

