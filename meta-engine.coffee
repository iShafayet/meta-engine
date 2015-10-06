
class MetaEngine

  optionMap: null
  contentProvider: null

  constuctor: (optionMap)->

    @optionMap = @__processOptionMap optionMap

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

    if not ('contentProvider' of optionMap) or not (typeof optionMap.contentProvider is 'object')
      optionMap.contentProvider = null

    return optionMap





@MetaEngine = MetaEngine

